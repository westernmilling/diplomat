require 'rails_helper'

feature 'User accepts an invite' do
  given(:email) { Faker::Internet.email }
  given(:name) { Faker::Name.name }
  given(:password) { Faker::Internet.password }
  given(:user) { create(:user) }
  given!(:invited_user) do
    User.invite!({ email: email, name: name }, user)
  end

  context 'when the details are valid' do
    given!(:invited_user) do
      User.invite!({ email: email, name: name }, user)
    end

    scenario 'they see a success message' do
      # NB: Leave the details as they were during the invite
      visit accept_user_invitation_path(
        invitation_token: invited_user.raw_invitation_token)

      expect(page).to have_content(I18n.t('devise.invitations.edit.header'))
      expect(page).to have_field(:entry_name, with: name)

      fill_in :entry_password, with: password
      fill_in :entry_password_confirmation, with: password

      click_on I18n.t('devise.invitations.edit.submit_button')

      expect(page)
        .to have_content(I18n.t('devise.invitations.updated_not_active'))
    end
  end

  context 'when details are not valid' do
    scenario 'they see an error message' do
      visit accept_user_invitation_path(
        invitation_token: invited_user.raw_invitation_token)

      expect(page).to have_content(I18n.t('devise.invitations.edit.header'))
      expect(page).to have_field(:entry_name, with: name)

      fill_in :entry_name, with: nil

      click_on I18n.t('devise.invitations.edit.submit_button')

      expect(page).to have_content(/Namecan't be blank/i)
      expect(page).to have_content(/Passwordcan't be blank/i)
      expect(page).to have_content(/Password confirmationcan't be blank/i)
    end
  end
end
