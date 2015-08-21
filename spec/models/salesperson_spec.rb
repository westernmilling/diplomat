require 'rails_helper'

RSpec.describe Salesperson, type: :model do
  subject do
    build(:salesperson,
          entity: create(:entity))
  end

  it { is_expected.to belong_to(:entity) }
  it { is_expected.to validate_presence_of(:entity) }
  it { is_expected.to validate_presence_of(:uuid) }

  describe '.active' do
    subject { Salesperson.active }
    before do
      create(:salesperson,
             entity: create(:entity),
             is_active: is_active)
      create(:salesperson,
             entity: create(:entity),
             is_active: is_active)
    end

    context 'when there are no active salespeople' do
      let(:is_active) { 0 }

      its(:any?) { is_expected.to be_falsey }
      its(:empty?) { is_expected.to be_truthy }
      its(:size) { is_expected.to eq(0) }
    end

    context 'when there are active salespeople' do
      let(:is_active) { 1 }

      its(:any?) { is_expected.to be_truthy }
      its(:empty?) { is_expected.to be_falsey }
      its(:size) { is_expected.to eq(2) }
    end
  end
end
