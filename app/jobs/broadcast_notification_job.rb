# frozen_string_literal: true

require 'net/http'
require 'active_support/core_ext'

# 全員にプッシュ通知するジョブ
class BroadcastNotificationJob < ApplicationJob
  queue_as :default

  def perform(title: 'お知らせ', message: 'お知らせの内容です')
    # 環境変数や Rails の設定から App ID と API Key を取得
    app_id = ONE_SIGNAL_CONFIG[:app_id]
    app_key = ONE_SIGNAL_CONFIG[:app_key]

    raise 'AppId or APIKey is required' if app_id.blank? || app_key.blank?

    # 通知内容を準備
    params = {
      app_id: app_id,
      headings: { en: title, ja: title }, # タイトルを設定
      contents: { en: message, ja: message }, # 本文を設定
      included_segments: ['All'], # 全員に送信
      isAnyWeb: true # Webプラットフォームのみに送信
    }

    # 通知を送信
    response = send_notification(params, app_key)
    JSON.parse(response.body)

    # レスポンスをログに記録
    Rails.logger.info("BroadcastNotificationJob response: #{response.body}")
  rescue StandardError => e
    Rails.logger.error("Error in BroadcastNotificationJob: #{e.message}")
    raise
  end

  private

  def send_notification(params, api_key)
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(
      uri.path,
      'Content-Type' => 'application/json',
      'Authorization' => "Basic #{api_key}"
    )
    request.body = params.as_json.to_json
    http.request(request)
  end
end
