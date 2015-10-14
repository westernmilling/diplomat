require 'rails_helper'

RSpec.describe Interface::IRely::CredentialParser, type: :model do
  let(:to) { OpenStruct.new }
  let(:key) { Faker::Lorem.word }
  let(:secret) { Faker::Lorem.word }
  let(:company_id) { Faker::Lorem.word }
  let(:model) { described_class.new("#{key}:#{secret}@#{company_id}") }

  describe '#parse_into' do
    describe 'to' do
      before { model.parse_into(to) }

      subject { to }

      its(:api_key) { is_expected.to eq key }
      its(:api_secret) { is_expected.to eq secret }
      its(:company_id) { is_expected.to eq company_id }
    end
  end
end
