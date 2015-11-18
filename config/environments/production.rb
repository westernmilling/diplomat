Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_files = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.active_record.dump_schema_after_migration = false
  config.log_formatter = ::Logger::Formatter.new
  config.logger = RemoteSyslogLogger.new(Figaro.env.REMOTE_SYSLOG_HOST,
                                         Figaro.env.REMOTE_SYSLOG_PORT)
  config.logger.level = Logger.const_get('INFO')
  config.log_level = (Figaro.env.REMOTE_SYSLOG_LEVEL || 'info').to_sym
end
