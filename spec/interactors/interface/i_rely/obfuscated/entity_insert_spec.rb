require 'rails_helper'

RSpec.describe Interface::IRely::Obfuscated::EntityInsert,
               type: :interactor,
               vcr: true do
  describe '.call' do
    let(:entity) do
      create(:entity)
    end
    let!(:customer) do
      create(:customer,
             entity: entity,
             bill_to_location: entity.locations[0],
             ship_to_location: entity.locations[0])
    end
    let(:call) do
      result = nil
      VCR.use_cassette('obfuscated_entity_customer') do
        result = Interface::IRely::Obfuscated::EntityInsert.call(entity: entity)
      end
      result
    end
    subject { call }

    # TODO: Use contexts for customer, vendor, combined inserts

    it { is_expected.to be_success }
    its(:status) { is_expected.to eq :success }
    its(:payload) { is_expected.to be_present }
    describe 'payload' do
      subject { call.payload }

      its([:data]) { is_expected.to be_present }
    end
    describe 'payload[data][0]' do
      subject { call.payload[:data][0] }

      its([:name]) { is_expected.to be_present }
    end
    its(:identifier) { is_expected.to be_present }
  end
end
