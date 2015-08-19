require 'rails_helper'

feature 'user views an organization' do
  background { sign_in_with(user.email, user.password) }
  given(:organization) { create(:organization) }
  given(:user) { create(:user, :admin) }

  scenario 'they see the organization' do
    visit organization_path(organization)

    expect(page).to have_content(organization.name)
  end

  context 'when the user is not authorized' do
    let(:user) { create(:user) }

    scenario "they see you're not permitted" do
      visit admin_user_path(user)

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
