require 'rails_helper'

RSpec.describe Integration, type: :model do
  it { is_expected.to have_many(:organizations) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:credentials) }
  it { is_expected.to validate_presence_of(:integration_type) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:uuid) }
end
