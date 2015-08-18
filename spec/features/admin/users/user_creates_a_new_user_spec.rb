require 'rails_helper'

feature 'User creates a new user' do
  background { sign_in_with(user.email, user.password) }
  let(:user) { create(:user) }

  context 'when details are valid' do
    scenario 'they see a success message' do
      visit new_admin_user_path

      fill_in :entry_name, with: Faker::Name.name
      fill_in :entry_email, with: Faker::Internet.email
      check 'Is active'
      click_button 'Save'

      expect(page).to have_content(I18n.t('users.create.success'))
    end
  end

  context 'when details are invalid' do
    scenario 'they see an error message' do
      visit new_admin_user_path

      click_button 'Save'

      expect(page).to have_content(/error/i)
    end
  end
end
