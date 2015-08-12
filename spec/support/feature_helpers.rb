module FeatureHelpers
  def use_no_subdomain
    use_subdomain('www')
  end

  def use_subdomain(subdomain)
    host = "http://#{subdomain}.#{Figaro.env.DOMAIN}"
    Capybara.app_host = host
    default_url_options[:host] = host
  end

  def sign_in_with(email, password)
    visit '/users/sign_in'

    fill_in 'Email address', with: email
    fill_in 'Password', with: password

    click_on 'Sign in'
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
