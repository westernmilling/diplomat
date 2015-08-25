require 'rails_helper'

feature 'user updates an existing organization' do
  background { sign_in_with(user.email, user.password) }
  given!(:integrations) { create_list(:integration, 2) }
  given(:organization) { create(:organization) }
  given(:user) { create(:user, :admin) }

  context 'when details are valid' do
    scenario 'they see a success message' do
      visit edit_admin_organization_path(organization)

      select integrations[0].to_s, from: :organization_integration_id

      click_button 'Save'

      expect(page).to have_content(I18n.t('organizations.update.success'))
    end
  end

  context 'when the user does not have the admin role' do
    given(:user) { create(:user, :authenticated) }

    scenario 'they see an access denied message' do
      visit edit_admin_organization_path(organization)

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
