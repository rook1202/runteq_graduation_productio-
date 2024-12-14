class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(remainder_id)
    Rails.logger.info("SendNotificationJob started with remainder_id: #{remainder_id}")

    # リマインダーと関連データの取得
    remainder = Remainder.find(remainder_id)
    # OneSignal に登録された外部ユーザー ID を取得
    user_ids = remainder.partner.owner.device_tokens.pluck(:user_id)

    Rails.logger.info("Fetched user_ids: #{user_ids.inspect}")

    # 通知内容を定義
    title = "リマインダー通知"
    body = "予定があります。"

    # OneSignal クライアントを使用して通知を送信
    client = OneSignal::Client.new
    response = client.notifications.create(
      app_id: OneSignal::Client.app_id,
      headings: { en: title },
      contents: { en: body },
      include_external_user_ids: user_ids # ユーザーIDを指定
    )

    # レスポンスをログに記録
    Rails.logger.info("OneSignal response: #{response.inspect}")
  rescue => e
    Rails.logger.error("Error in SendNotificationJob: #{e.message}")
    raise
  end
end