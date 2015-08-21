require 'rails_helper'

RSpec.describe Vendor, type: :model do
  subject { build(:vendor, entity: create(:entity)) }

  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to belong_to(:entity) }
  it { is_expected.to validate_presence_of(:entity) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_inclusion_of(:is_active).in_range(0..1) }

  describe '#active?' do
    let(:vendor) { build(:vendor, is_active: is_active) }
    subject { vendor.active? }

    context 'when is_active equals 0' do
      let(:is_active) { 0 }

      it { is_expected.to eq(false) }
    end

    context 'when is_active equals 1' do
      let(:is_active) { 1 }

      it { is_expected.to eq(true) }
    end
  end
end
