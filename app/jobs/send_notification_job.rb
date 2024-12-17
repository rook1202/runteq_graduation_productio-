require 'onesignal'

class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(remainder_id)
    Rails.logger.info("SendNotificationJob started with remainder_id: #{remainder_id}")

    # リマインダーと関連データの取得
    remainder = Remainder.find(remainder_id)
    player_ids = remainder.partner.owner.device_tokens.pluck(:player_id)

    Rails.logger.info("Fetched player_ids: #{player_ids.inspect}")

    # 通知内容を定義
    title = "リマインダー通知"
    body = "予定があります。"

    api_instance = OneSignal::DefaultApi.new

    notification = OneSignal::Notification.new(
      app_id: ONE_SIGNAL_CONFIG[:app_id],
      headings: { en: "初期化確認" },
      contents: { en: "OneSignal の初期化が成功しました！" },
      include_player_ids: player_ids
    )

    notifcation.isAnyWeb = true

    puts "check: #{notification}"

    begin
      response = api_instance.create_notification(notification)
      puts "Notification response: #{response.inspect}"
    rescue OneSignal::ApiError => e
      puts "Error when calling OneSignal API: #{e.response_body}"
    end
  end