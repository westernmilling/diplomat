require 'rails_helper'

feature 'user views an organization' do
  background { sign_in_with(user.email, user.password) }
  given(:organization) { create(:organization) }
  given(:user) { create(:user, :authenticated) }

  scenario 'they see the organization' do
    visit organization_path(organization)

    expect(page).to have_content(organization.name)
  end
end
