require 'rails_helper'

feature 'User invites a new user' do
  background { sign_in_with(user.email, user.password) }
  given(:user) { create(:user) }

  context 'when details are valid' do
    given(:email) { Faker::Internet.email }
    given(:name) { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }

    scenario 'they see an invitation sent message' do
      visit new_user_invitation_path

      expect(page).to have_content(I18n.t('devise.invitations.new.header'))

      fill_in :entry_email, with: email
      fill_in :entry_name, with: name

      click_on 'Send'

      expect(page)
        .to have_content(I18n.t('devise.invitations.send_instructions',
                                email: email))
    end
  end

  context 'when details are not valid' do
    given(:email) {}
    given(:name) {}

    scenario 'they see an error message' do
      visit new_user_invitation_path

      expect(page).to have_content(I18n.t('devise.invitations.new.header'))

      fill_in :entry_email, with: email
      fill_in :entry_name, with: name

      click_on 'Send'

      expect(page).to have_content(/error/i)
    end
  end
end
