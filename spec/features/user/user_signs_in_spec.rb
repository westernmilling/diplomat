require 'rails_helper'

feature 'User signs in' do
  given(:user) { create(:user) }

  context 'when the details are not valid' do
    scenario 'they see invalid email or password' do
      visit new_user_session_path

      fill_in :user_email, with: user.email
      fill_in :user_password, with: nil

      click_on 'Sign in'

      expect(page)
        .to have_content(I18n.t('devise.failure.invalid',
                                authentication_keys: 'email'))
    end
  end
  context 'when the details are valid' do
    scenario 'they see you sign in successfully' do
      visit new_user_session_path

      fill_in :user_email, with: user.email
      fill_in :user_password, with: user.password

      click_on 'Sign in'

      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    end
  end
end
