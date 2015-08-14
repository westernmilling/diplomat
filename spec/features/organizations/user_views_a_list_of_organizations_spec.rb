require 'rails_helper'

feature 'user views a list of organizations' do
  background { sign_in_with(user.email, user.password) }
  given(:user) { create(:user, :authenticated) }

  context 'when there are no organizations' do
    given(:organizations) {}

    scenario 'they see no organizations' do
      visit organizations_path

      expect(page)
        .to have_content(I18n.t('organizations.index.none'))
    end
  end

  context 'when there are some organizations' do
    given(:organizations) { create_list(:organization, 3) }

    scenario 'they see a table of organizations' do
      visit organizations_path

      expect(page).to have_css('table tbody tr', 3)
    end
  end
end
