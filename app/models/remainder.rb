# frozen_string_literal: true

# ペットの各行動時間に関するモデルです。
class Remainder < ApplicationRecord
  belongs_to :partner
  belongs_to :activity, polymorphic: true # 複数の活動（Food, Walk, Medicationなど）を扱う

  def schedule_notification
    notification_time = Time.zone.parse(time).utc # TZで変換後UTCに変換
    Rails.logger.debug "notification_time: #{notification_time}"
    job = SendNotificationJob.set(wait_until: notification_time).perform_later(id)
    update!(job_id: job.job_id)
  end

  def cancel_notification
    return unless job_id

    delete_scheduled_job
    delete_waiting_job
    clear_job_id
  end

  private

  def delete_scheduled_job
    Sidekiq::ScheduledSet.new.each do |entry|
      if entry.item['args'].first['job_id'] == job_id
        entry.delete
        Rails.logger.info "Successfully deleted scheduled job: #{job_id} for Remainder: #{id}"
      end
    end
  end

  def delete_waiting_job
    Sidekiq::Queue.new.each do |job|
      if job.args.first['job_id'] == job_id
        job.delete
        Rails.logger.info "Successfully deleted waiting job: #{job_id} for Remainder: #{id}"
      end
    end
  end

  def clear_job_id
    update!(job_id: nil)
    Rails.logger.debug "Cleared job_id for Remainder: #{id}"
  end
end
