require 'rails_helper'

RSpec.describe UpdateUser, type: :service do
  describe '.call' do
    let(:user) { create(:user) }
    let(:email) { Faker::Internet.email }
    let(:name) { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    let(:context) do
      UpdateUser.call(
        id: user.id,
        name: name,
        email: email,
        # roles: roles,
        current_user: acting_user)
    end
    let!(:acting_user) { create(:user) }

    context 'when the details are valid' do
      describe Interactor::Context do
        subject { context }

        its(:success?) { is_expected.to be true }
        its(:message) do
          is_expected
            .to eq(I18n.t('users.update.success'))
        end

        describe '#user' do
          subject { context.user }

          it { is_expected.to be_present }
          it { is_expected.to be_persisted }
          its(:email) { is_expected.to eq(email) }
          its(:name) { is_expected.to eq(name) }
          # its(:roles) do
          #   expect(subject.roles.map(&:name))
          #     .to include('authenticated', 'admin')
          # end
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
            .to eq(I18n.t('users.update.invalid'))
        end

        describe '#user' do
          subject { context.user }

          it { is_expected.to_not be_present }
        end
      end
    end
  end
end
