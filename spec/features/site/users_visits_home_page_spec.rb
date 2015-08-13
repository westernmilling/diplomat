require 'rails_helper'

feature 'User visits home page' do
  context 'when they are signed in' do
    background do
      sign_in_with(user.email, user.password)
    end
    given(:user) { create(:user) }

    scenario 'they see a sign out link' do
      visit root_path

      expect(page)
        .to have_css('li a', text: I18n.t('sign_out.title'))
    end
  end

  context 'when they are not signed in' do
    scenario 'they see a sign in link' do
      visit root_path

      expect(page)
        .to have_css('li a', text: I18n.t('sign_in.title'))
    end
  end
end
