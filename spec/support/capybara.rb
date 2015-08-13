require 'capybara/rails'

Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.allow_url('fonts.googleapis.com')
end
