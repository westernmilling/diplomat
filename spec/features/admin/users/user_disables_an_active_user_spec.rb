require 'rails_helper'

feature 'User disables an active user' do
  background do
    sign_in_with(current_user.email, current_user.password)
  end
  given(:current_user) { create(:user, :admin) }
  given(:other_user) { create(:user) }

  scenario 'they see the has been disabled' do
    visit edit_admin_user_path(other_user)

    uncheck 'Is active'

    click_on 'Save'

    expect(page).to have_content('Inactive')
  end
end
