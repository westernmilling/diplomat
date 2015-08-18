require 'rails_helper'

feature 'User views a single user' do
  background do
    sign_in_with(user.email, user.password)
  end
  given(:user) { create(:user) }

  scenario 'they see the user' do
    visit admin_user_path(user)

    expect(page).to have_content(user.name)
  end
end
