require 'rails_helper'

RSpec.describe Users::InvitationsController, type: :controller do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  let(:token) { Devise.token_generator.generate(User, :invitation_token)[0] }

  describe 'GET edit' do
    before do
      allow(User).to receive(:find_by_invitation_token) { user }

      get :edit, invitation_token: token
    end
    let(:user) { build_stubbed(:user) }

    context 'when the token is valid' do
      it_behaves_like 'a successful request'
      it_behaves_like 'an edit request'
      it { expect(assigns(:entry)).to be_kind_of(AcceptInviteEntry) }
    end

    context 'when the token is not valid' do
      let(:user) { nil }

      it_behaves_like 'a redirect'
      it do
        is_expected
          .to set_flash[:alert]
          .to(I18n.t('devise.invitations.invitation_token_invalid'))
      end
    end
  end

  describe 'PATCH update' do
    before do
      allow(AcceptUserInvite).to receive(:call).and_return(context)
      allow(User).to receive(:find_by_invitation_token) { user }

      patch :update,
            entry: { name: name,
                     password: password,
                     password_confirmation: password,
                     invitation_token: token
            }
    end
    let(:context) do
      double(:context, invited_user: user, success?: success?)
    end
    let(:password) { Faker::Internet.password }
    let(:success?) { true }
    let(:user) { build_stubbed(:user) }

    context 'when the details are valid' do
      let(:email) { Faker::Internet.email }
      let(:name) { Faker::Internet.name }

      it_behaves_like 'a redirect'
      it do
        is_expected
          .to set_flash[:notice]
          .to(I18n.t('devise.invitations.updated_not_active'))
      end
    end

    context 'when the details are not valid' do
      let(:email) {}
      let(:name) {}

      it_behaves_like 'a successful request'
      it_behaves_like 'an edit request'
      it { expect(assigns(:entry)).to be_kind_of(AcceptInviteEntry) }
      it { expect(assigns(:entry).errors).to_not be_empty }
    end

    context 'when the token is not valid' do
      let(:email) { Faker::Internet.email }
      let(:name) { Faker::Internet.name }
      let(:user) { nil }

      it_behaves_like 'a redirect'
      it do
        is_expected
          .to set_flash[:alert]
          .to(I18n.t('devise.invitations.invitation_token_invalid'))
      end
    end
  end
end
