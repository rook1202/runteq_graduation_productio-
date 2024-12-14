# frozen_string_literal: true

# ペットの各行動時間に関するモデルです。
class Remainder < ApplicationRecord
  belongs_to :partner
  belongs_to :activity, polymorphic: true # 複数の活動（Food, Walk, Medicationなど）を扱う

  def schedule_notification
    notification_time = Time.zone.parse(time).utc # TZで変換後UTCに変換
    puts "notification_time: #{notification_time}"
    job = SendNotificationJob.set(wait_until: notification_time).perform_later(id)
    update_column(:job_id, job.job_id)
  end

  def cancel_notification
    return unless job_id # ジョブIDが存在しない場合は処理しない
  
    scheduled_jobs = Sidekiq::ScheduledSet.new
    scheduled_jobs.each do |entry|
      if entry.item['args'].first['job_id'] == job_id
        entry.delete
        puts "Deleted job: #{job_id}"
      end
    end
  
    update_column(:job_id, nil) # キャンセル後にジョブIDをクリア
  end
end
