require 'rails_helper'

feature 'User creates a new user' do
  background { sign_in_with(user.email, user.password) }
  let(:user) { create(:user, :admin) }

  context 'when details are valid' do
    let(:name) { Faker::Name.name }

    scenario 'they see a success message' do
      visit new_admin_user_path

      fill_in :entry_name, with: name
      fill_in :entry_email, with: Faker::Internet.email
      select 'authenticated', from: :entry_role_names
      select 'admin', from: :entry_role_names
      check 'Is active'
      click_button 'Save'

      expect(page).to have_content(I18n.t('users.create.success'))
      expect(page).to have_content(name)
      expect(page).to have_content('authenticated')
      expect(page).to have_content('admin')
    end
  end

  context 'when details are invalid' do
    scenario 'they see an error message' do
      visit new_admin_user_path

      click_button 'Save'

      expect(page).to have_content(/error/i)
    end
  end

  context 'when the user is not authorized' do
    let(:user) { create(:user) }

    scenario "they see you're not permitted" do
      visit new_admin_user_path

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
