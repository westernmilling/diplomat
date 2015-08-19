require 'rails_helper'

RSpec.describe InviteUser, type: :service do
  describe '.call' do
    let(:email) { Faker::Internet.email }
    let(:name) { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    let(:context) do
      InviteUser.call(
        name: name,
        email: email,
        role_names: ['authenticated', 'admin'],
        current_user: acting_user)
    end
    let!(:acting_user) { create(:user) }

    context 'when the details are valid' do
      describe Interactor::Context do
        subject { context }

        its(:success?) { is_expected.to be true }
        its(:message) do
          is_expected
            .to eq(I18n.t('users.create.success'))
        end

        describe '#user' do
          subject { context.user }

          it { is_expected.to be_present }
          it { is_expected.to be_persisted }
          its(:email) { is_expected.to eq(email) }
          its(:name) { is_expected.to eq(name) }
          its(:roles) do
            expect(subject.roles.map(&:name))
              .to include('authenticated', 'admin')
          end
          its(:invitation_created_at) { is_expected.to be_present }
          its(:invitation_sent_at) { is_expected.to be_present }
          its(:invitation_token) { is_expected.to be_present }
          its(:invited_by_id) { is_expected.to eq(acting_user.id) }
          its(:invited_by_type) { is_expected.to eq('User') }
        end

        describe 'membership message' do
          it 'should send an email to the invited user' do
            ActionMailer::Base.deliveries = []
            expect do
              subject
            end.to change(ActionMailer::Base.deliveries, :size).by(1)
          end
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
            .to eq(I18n.t('users.create.invalid'))
        end

        describe '#user' do
          subject { context.user }

          it { is_expected.to_not be_present }
        end
      end

      it_behaves_like 'sending no email'
    end
  end
end
