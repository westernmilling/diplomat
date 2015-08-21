require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:entity) { build(:entity) }
  subject { Location.new }

  it { should be_kind_of(Disableable) }
  it { is_expected.to belong_to(:entity) }
  it { is_expected.to validate_presence_of(:cached_long_address) }
  it { is_expected.to validate_presence_of(:entity) }
  it { is_expected.to validate_presence_of(:location_name) }
  it { is_expected.to validate_presence_of(:street_address) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:region) }
  it { is_expected.to validate_presence_of(:region_code) }
  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_presence_of(:uuid) }
end
