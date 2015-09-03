require 'rails_helper'

RSpec.describe Interface::IRely::EntityInsert, type: :interactor, vcr: true do
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
      VCR.use_cassette('entity_customer') do
        result = Interface::IRely::EntityInsert.call(entity: entity)
      end
      result
    end
    subject { call }

    # TODO: Use contexts for customer, vendor, combined updates

    it { is_expected.to be_success }
    its(:status) { is_expected.to eq :success }
    its(:response) { is_expected.to be_present }
    its(:payload) { is_expected.to be_present }
    describe 'payload' do
      subject { call.payload }

      its([:data]) { is_expected.to be_present }
    end
    describe 'payload[data][0]' do
      subject { puts call.payload[:data]; call.payload[:data][0] }

      its([:name]) { is_expected.to be_present }
      its([:interface_id]) { is_expected.to be_present }
      its([:i21_id]) { is_expected.to_not be_present }
    end
    # its(:identifier) { is_expected.to be_present }
  end
end
