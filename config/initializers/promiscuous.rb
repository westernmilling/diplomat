Promiscuous.configure do |config|
  config.amqp_url = Figaro.env.MQ_URL
  # config.redis_url = 'redis://localhost/'
  config.backend = :bunny
  config.logger = Rails.logger
  config.error_notifier = proc { |exception| Rails.logger.error exception }
end
