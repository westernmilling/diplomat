if ENV['SMTP_SERVER']
  ActionMailer::Base.smtp_settings = {
    port: ENV.fetch('SMTP_PORT'),
    address: ENV.fetch('SMTP_SERVER'),
    user_name: ENV.fetch('SMTP_LOGIN'),
    password: ENV.fetch('SMTP_PASSWORD'),
    authentication: :plain
  }
end

ActionMailer::Base.delivery_method = :smtp unless Rails.env.to_sym == :test
ActionMailer::Base.smtp_settings ||= {}
ActionMailer::Base.smtp_settings.merge!(ENV.to_h.symbolize_keys.slice(:domain))
ActionMailer::Base.default_url_options[:host] = ENV.fetch('DOMAIN')
