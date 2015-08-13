require 'rails_helper'

RSpec.describe AcceptUserInvite, type: :service do
  describe '.call' do
    let(:email) { Faker::Internet.email }
    let(:name) { Faker::Name.name }
    let(:invited_user) do
      User.invite!({ email: email, name: name }, acting_user)
    end
    let(:password) { Faker::Internet.password }
    let(:context) do
      AcceptUserInvite.call(
        name: name,
        password: password,
        password_confirmation: password,
        invitation_token: invited_user.raw_invitation_token,
        current_user: acting_user)
    end
    let!(:acting_user) { create(:user) }

    context 'when the details are valid' do
      describe Interactor::Context do
        subject { context }

        its(:success?) { is_expected.to be true }
        its(:message) do
          is_expected
            .to eq(I18n.t('user.invite.accepted'))
        end

        describe '#invited_user' do
          subject { context.invited_user }

          it { is_expected.to be_present }
          it { is_expected.to be_persisted }
          its(:email) { is_expected.to eq(email) }
          its(:name) { is_expected.to eq(name) }
          its(:invitation_accepted_at) { is_expected.to be_present }
        end
      end
    end

    context 'when the details are invalid' do
      let(:name) {}
      subject { context }

      describe Interactor::Context do
        its(:success?) { is_expected.to be false }
        its(:message) do
          is_expected
            .to eq(I18n.t('user.invite.invalid'))
        end

        describe '#invited_user' do
          subject { context.invited_user }

          it { is_expected.to_not be_present }
        end
      end
    end
  end
end
