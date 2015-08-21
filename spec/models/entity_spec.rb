require 'rails_helper'

RSpec.describe Entity, type: :model do
  subject { build(:entity) }

  it { is_expected.to belong_to(:parent_entity) }
  it { is_expected.to have_many(:contacts) }
  it { is_expected.to have_many(:locations) }
  it { is_expected.to have_one(:contact) }
  it { is_expected.to validate_presence_of(:entity_type) }
  it { is_expected.to validate_presence_of(:cached_long_name) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:reference) }
  it { is_expected.to validate_presence_of(:uuid) }
  it { is_expected.to validate_uniqueness_of(:reference) }
  it do
    is_expected
      .to enumerize(:entity_type).in(:company, :person).with_default(:company)
  end
  it do
    is_expected
      .to enumerize(:ten99_form)
      .in(:crop_insurance_proceeds, :direct_sales,
          :excess_golden_parachute_payments, :federal_income_tax_withheld,
          :fish_boat_proceeds, :gross_proceeds_paid_to_an_attorney,
          :medical_and_health_care_payments, :non_employee_compensation,
          :other_income, :rents, :royalties,
          :subsitute_payments_in_lieu_of_dividends_or_interest)
  end
  it do
    is_expected
      .to enumerize(:ten99_type).in(:none, :ten99_misc, :ten99_int, :ten99_b)
  end

  describe '#active?' do
    let(:entity) { build(:entity, is_active: is_active) }
    subject { entity.active? }

    context 'when is_active equals 0' do
      let(:is_active) { 0 }

      it { is_expected.to eq(false) }
    end

    context 'when is_active equals 1' do
      let(:is_active) { 1 }

      it { is_expected.to eq(true) }
    end
  end

  describe '#to_s' do
    let(:entity) { build(:entity) }
    subject { entity.to_s }

    it { is_expected.to eq(entity.name) }
  end
end
