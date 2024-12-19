# frozen_string_literal: true

require 'onesignal'

# 特定のデバイスに対するプッシュ通知の送信ジョブ
class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(remainder_id)
    Rails.logger.info("SendNotificationJob started with remainder_id: #{remainder_id}")

    # リマインダーと関連データの取得
    remainder = Remainder.find(remainder_id)
    player_ids = remainder.partner.owner.device_tokens.pluck(:player_id)

    Rails.logger.info("Fetched player_ids: #{player_ids.inspect}")

    # 通知内容を定義
    title = 'リマインダー通知'
    body = '予定があります。'

    api_instance = OneSignal::DefaultApi.new

    notification = OneSignal::Notification.new({
                                                 app_id: ONE_SIGNAL_CONFIG[:app_id],
                                                 headings: { en: title },
                                                 contents: { en: body },
                                                 include_player_ids: player_ids,
                                                 is_chrome_web: true,
                                                 is_any_web: true
                                               })

    Rails.logger.info("Notification before API call: #{notification.inspect}")

    begin
      response = api_instance.create_notification(notification)
      Rails.logger.info "Notification successfully sent. Response: #{response.inspect}"
    rescue OneSignal::ApiError => e
      Rails.logger.debug "Error when calling OneSignal API: #{e.response_body}"
    end
  end
end
