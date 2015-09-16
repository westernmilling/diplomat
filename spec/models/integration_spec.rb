require 'rails_helper'

RSpec.describe Integration, type: :model do
  it { is_expected.to have_many(:organizations) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:credentials) }
  it { is_expected.to validate_presence_of(:integration_type) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:uuid) }

  it do
    is_expected
      .to enumerize(:integration_type)
      .in('i_rely', 'i_rely/obfuscated', 'test')
  end

  describe '#interface_namespace' do
    subject do
      build(:integration,
            integration_type: 'i_rely/obfuscated').interface_namespace
    end

    it { is_expected.to eq Interface::IRely::Obfuscated }
  end
end
