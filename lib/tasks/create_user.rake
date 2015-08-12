namespace :diplomat do
  desc 'Creates a new user'
  task(:create_user, [:email_address, :name] => :environment) do |_t, args|
    password = Devise.friendly_token.first(15)

    user = User.find_by(email: args.email_address)
    user ||= User.new do |u|
      u.email = args.email_address
      u.name = args.name
      u.password = password
      u.password_confirmation = password
    end

    user.save!

    puts "Created user #{user.email} with password #{password}"
  end
end
