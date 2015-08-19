require 'rails_helper'

feature 'User updates an existing user' do
  background { sign_in_with(current_user.email, current_user.password) }
  let(:current_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  context 'when details are valid' do
    scenario 'they see a success message' do
      visit edit_admin_user_path(user)

      fill_in :entry_name, with: Faker::Name.name
      fill_in :entry_email, with: Faker::Internet.email
      check 'Is active'
      click_button 'Save'

      expect(page).to have_content(I18n.t('users.update.success'))
    end
  end

  context 'when details are invalid' do
    scenario 'they see an error message' do
      visit edit_admin_user_path(user)

      fill_in :entry_name, with: nil
      click_button 'Save'

      expect(page).to have_content(/error/i)
    end
  end

  context 'when the user is not authorized' do
    let(:current_user) { create(:user) }

    scenario "they see you're not permitted" do
      visit edit_admin_user_path(user)

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
