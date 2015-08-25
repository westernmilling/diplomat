require 'rails_helper'

feature 'user views a list of integrations' do
  background { sign_in_with(user.email, user.password) }
  given(:user) { create(:user, :admin) }

  context 'when there are no integrations' do
    given(:integrations) {}

    scenario 'they see no integrations' do
      visit admin_integrations_path

      expect(page).to have_content(I18n.t('integrations.index.none'))
    end
  end

  context 'when there are some integrations' do
    given(:integrations) { create_list(:integration, 3) }

    scenario 'they see a table of integrations' do
      visit admin_integrations_path

      expect(page).to have_css('table tbody tr', 3)
    end
  end

  context 'when the user does not have the admin role' do
    given(:user) { create(:user, :authenticated) }

    scenario 'they see an access denied message' do
      visit admin_integrations_path

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
