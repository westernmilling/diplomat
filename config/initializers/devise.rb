Devise.setup do |config|
  require 'devise/orm/active_record'

  config.secret_key = Figaro.env.SECRET_KEY_BASE
  config.mailer_sender = Figaro.env.MAILER_SENDER
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.validate_on_invite = true
  config.allow_insecure_sign_in_after_accept = false
  config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  config.extend_remember_period = true
  config.password_length = 8..128
  config.lock_strategy = :failed_attempts
  config.unlock_keys = [:email]
  config.unlock_strategy = :both
  config.maximum_attempts = 20
  config.unlock_in = 1.hour
  config.last_attempt_warning = true
  config.reset_password_within = 6.hours

  # rubocop:disable Metrics/LineLength
  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  # rubocop:enable Metrics/LineLength
  # config.scoped_views = false

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  # config.default_scope = :user

  # Set this configuration to false if you want /users/sign_out to sign out
  # only the current scope. By default, Devise signs out all scopes.
  # config.sign_out_all_scopes = true
  # rubocop:enable Metrics/LineLength

  config.sign_out_via = :delete
end
