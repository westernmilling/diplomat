require 'rails_helper'

RSpec.describe UpdateUser, type: :service do
  describe '.call' do
    let(:user) do
      create(:user) { |u| %w{admin authenticated}.each { |r| u.grant r } }
    end
    let(:email) { Faker::Internet.email }
    let(:name) { Faker::Name.name }
    let(:context) do
      UpdateUser.call(
        id: user.id,
        name: name,
        email: email,
        role_names: role_names,
        current_user: acting_user)
    end
    let!(:acting_user) { create(:user) }

    context 'when the details are valid' do
      let(:role_names) { %w{authenticated admin} }

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
          its(:roles) do
            expect(subject.roles.map(&:name))
              .to include('authenticated', 'admin')
          end
        end
      end
    end

    context 'when removing all roles' do
      let(:role_names) {}

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
          its(:roles) { is_expected.to be_empty }
        end
      end
    end

    context 'when the details are invalid' do
      let(:name) {}
      let(:role_names) {}
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
