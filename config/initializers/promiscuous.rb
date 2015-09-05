Promiscuous.configure do |config|
  config.amqp_url = Figaro.env.MQ_URL
  config.rabbit_mgmt_url = Figaro.env.MQ_MGMT_URL
  config.redis_url = Figaro.env.PROMISCUOUS_REDIS_URL
  config.backend = :bunny
  config.logger = Rails.logger
  config.error_notifier = proc { |exception| Rails.logger.error exception }
end
