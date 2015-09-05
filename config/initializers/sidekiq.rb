Sidekiq.configure_server do |config|
  config.redis = { url: Figaro.env.SIDEKIQ_REDIS_URL }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Figaro.env.SIDEKIQ_REDIS_URL }
end
