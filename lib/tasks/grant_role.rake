namespace :diplomat do
  desc 'Grants a role to an existing user'
  task(
    :grant_role,
    [:email_address, :role] => :environment) do |_t, args|
    user = User.where { email == args.email_address }.first
    puts "Adding role #{args.role} to user #{user.email}"
    user.add_role args.role.to_sym
    user.save!
  end
end
