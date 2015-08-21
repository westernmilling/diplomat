require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { build(:customer, entity: build(:entity)) }

  it { is_expected.to belong_to(:bill_to_location).class_name(Location) }
  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:entity) }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to belong_to(:parent_customer) }
  it { is_expected.to belong_to(:salesperson) }
  it { is_expected.to belong_to(:ship_to_location).class_name(Location) }
  it { is_expected.to validate_presence_of(:bill_to_location) }
  it { is_expected.to validate_presence_of(:entity) }
  it { is_expected.to validate_presence_of(:ship_to_location) }
  it { is_expected.to validate_presence_of(:uuid) }

  describe '#active?' do
    let(:customer) do
      build(:customer, entity: build(:entity), is_active: is_active)
    end
    subject { customer.active? }

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
