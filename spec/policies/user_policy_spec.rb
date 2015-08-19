require 'rails_helper'

describe UserPolicy, type: :policy do
  before do
    relation = User.all
    allow(relation).to receive(:exists?).and_return(true)
    allow(User)
      .to receive(:where).with(id: record.id) { relation }
  end
  let(:organization) { build_stubbed(:organization) }
  let(:record) { build_stubbed(:user) }
  let(:user) { build_stubbed(:user) { |u| roles.each { |r| u.add_role r } } }

  subject { UserPolicy.new(user, record) }

  context 'when no user' do
    let(:user) { nil }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context 'when user has no roles' do
    let(:roles) { [] }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context 'when user has the admin role' do
    let(:roles) { [:authenticated, :admin] }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when user does not have the admin role' do
    let(:roles) { [:authenticated] }

    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
