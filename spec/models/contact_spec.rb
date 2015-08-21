require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:entity) { build(:entity) }
  subject { build(:contact, entity: entity) }

  it { should be_kind_of(Disableable) }

  it { is_expected.to belong_to(:entity) }
  it { is_expected.to validate_presence_of(:entity) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:uuid) }
end
