require 'onesignal'

# onesignal.yml の app_id と credentials.yml.enc の app_key を統合
ONE_SIGNAL_CONFIG = Rails.application.credentials.onesignal[Rails.env.to_sym]

# OneSignal の設定を適用
OneSignal.configure do |config|
  config.app_key = ONE_SIGNAL_CONFIG["app_key"] # REST API Key を使用
end