require 'rails_helper'

RSpec.describe UserDecorator, type: :decorator do
  describe '#active_label' do
    subject { user.decorate.active_label }

    context 'when is_active is 0' do
      let(:user) { build_stubbed(:user, is_active: 0) }

      it { is_expected.to eq 'Inactive' }
    end

    context 'when is_active is 1' do
      let(:user) { build_stubbed(:user, is_active: 1) }

      it { is_expected.to eq 'Active' }
    end
  end

  describe '#role_labels' do
    subject { user.decorate.role_labels }

    context 'when roles are empty' do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to be_nil }
    end

    context 'when roles are present' do
      let(:roles) { %w{admin authenticated} }
      let(:user) do
        build_stubbed(:user) { |u| roles.each { |r| u.grant r } }
      end

      it { is_expected.to include(*roles) }
    end
  end
end
