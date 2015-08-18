require 'rails_helper'

feature 'User views a list of users' do
  background do
    sign_in_with(user.email, user.password)
  end
  given(:users) { create_list(:user, 3) }
  given(:user) do
    users[0]
  end

  scenario 'they see the list of users' do
    visit admin_users_path

    expect(page).to have_content('Users')
    expect(page).to have_content(users[0].name)
    expect(page).to have_content(users[1].name)
    expect(page).to have_content(users[2].name)
  end
end
