Promiscuous.configure do |config|
  config.app            = 'diplomat'
  config.amqp_url       = 'amqp://guest:guest@localhost:5672'
  # config.redis_url      = 'redis://localhost/'
  config.backend        = :bunny
  config.logger         = Rails.logger
  config.error_notifier = proc { |exception| puts exception }
end
