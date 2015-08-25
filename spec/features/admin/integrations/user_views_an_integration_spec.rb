require 'rails_helper'

feature 'user views an integration' do
  background { sign_in_with(user.email, user.password) }
  given(:integration) { create(:integration) }
  given(:user) { create(:user, :admin) }

  scenario 'they see the integration' do
    visit admin_integration_path(integration)

    expect(page).to have_content(integration.name)
  end

  context 'when the user does not have the admin role' do
    given(:user) { create(:user, :authenticated) }

    scenario 'they see an access denied message' do
      visit admin_integration_path(integration)

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
