require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { is_expected.to act_as_paranoid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:uuid) }
  its(:to_s) { is_expected.to eq subject.name }

  describe '.new' do
    subject { Organization.new }

    its(:uuid) { is_expected.to be_present }
  end
end
