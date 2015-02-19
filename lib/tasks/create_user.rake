namespace :diplomat do
  desc 'Creates a new user'
  task(
    :create_user,
    [
      :email_address,
      :first_name,
      :last_name,
      :password
    ] => :environment) do |_t, args|
    user = User.where { email == args.email_address }.first
    user ||= User.new do |u|
      u.email = args.email_address
      u.first_name = args.first_name
      u.last_name = args.last_name
      u.display_name = "#{args.first_name} #{args.last_name}".strip
      u.password = args.password
      u.password_confirmation = args.password
      u.skip_confirmation!
    end

    user.save!
  end
end
