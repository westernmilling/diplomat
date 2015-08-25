require 'rails_helper'

feature 'user updates an existing integration' do
  background { sign_in_with(user.email, user.password) }
  given(:integration) { create(:integration) }
  given(:user) { create(:user, :admin) }

  context 'when details are valid' do
    scenario 'they see a success message' do
      visit edit_admin_integration_path(integration)

      fill_in :integration_name, with: Faker::Lorem.word
      select 'irely', from: :integration_integration_type
      fill_in :integration_address, with: Faker::Internet.url
      fill_in :integration_credentials,
              with: "#{Faker::Internet.user_name}:#{Faker::Internet.password}"

      click_button 'Save'

      expect(page).to have_content(I18n.t('integrations.update.success'))
    end
  end

  context 'when details are invalid' do
    scenario 'they see an error message' do
      visit edit_admin_integration_path(integration)

      fill_in :integration_name, with: nil

      click_button 'Save'

      expect(page).to have_content(/error/i)
    end
  end

  context 'when the user does not have the admin role' do
    given(:user) { create(:user, :authenticated) }

    scenario 'they see an access denied message' do
      visit edit_admin_integration_path(integration)

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
