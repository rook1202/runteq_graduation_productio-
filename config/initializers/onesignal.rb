require 'onesignal'

ONE_SIGNAL_CONFIG = YAML.load_file(Rails.root.join("config/onesignal.yml"))[Rails.env]

OneSignal.configure do |config|
  config.app_key = ONE_SIGNAL_CONFIG["app_key"] # REST API Key を使用
end