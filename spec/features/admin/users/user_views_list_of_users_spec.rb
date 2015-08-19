require 'rails_helper'

feature 'User views a list of users' do
  background do
    sign_in_with(current_user.email, current_user.password)
  end
  given!(:users) { create_list(:user, 3) }
  given(:current_user) { create(:user, :admin) }

  scenario 'they see the list of users' do
    visit admin_users_path

    expect(page).to have_content('Users')
    expect(page).to have_content(current_user.name)
    expect(page).to have_content(users[0].name)
    expect(page).to have_content(users[1].name)
    expect(page).to have_content(users[2].name)
  end

  context 'when the user is not authorized' do
    let(:current_user) { create(:user) }

    scenario "they see you're not permitted" do
      visit admin_users_path

      expect(page).to have_content(I18n.t('access_denied'))
    end
  end
end
