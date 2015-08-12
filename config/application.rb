require File.expand_path('../boot', __FILE__)

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Diplomat
  # Application
  class Application < Rails::Application
    # config.time_zone = 'Central Time (US & Canada)'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.test_framework :rspec, fixture: false
      g.view_specs false
      g.helper_specs false
    end

    config.secret_key_base = Figaro.env.SECRET_KEY_BASE
  end
end
