require 'rails_helper'

feature 'User enables an active user' do
  background do
    sign_in_with(current_user.email, current_user.password)
  end
  given(:current_user) { create(:user) }
  given(:other_user) { create(:user, is_active: 0) }

  scenario 'they see the has been enabled' do
    visit edit_admin_user_path(other_user)

    check 'Is active'

    click_on 'Save'

    expect(page).to have_content('Active')
  end
end
