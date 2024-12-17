Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' } # コンテナ名を'redis'とする場合
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end