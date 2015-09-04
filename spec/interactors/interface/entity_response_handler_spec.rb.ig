require 'rails_helper'

RSpec.describe Interface::EntityResponseHandler, type: :model do
  before do
    allow(entity).to receive(:customer).and_return(customer)
    allow(entity).to receive(:contacts).and_return(contacts)
    allow(entity).to receive(:locations).and_return(locations)
  end
  let(:contacts) { build_stubbed_list(:contact, 1, entity: entity) }
  let(:customer) { build_stubbed(:customer, entity: entity) }
  let(:entity) { build_stubbed(:entity) }
  let(:locations) { build_stubbed_list(:location, 1, entity: entity) }
  let(:response) do
    {
      contacts: contacts.map { |x| { id: x.id, interface_id: x.id + 10000 } },
      customer: { id: customer.id, interface_id: customer.id + 10000 },
      locations: locations.map { |x| { id: x.id, interface_id: x.id + 10000 } },
      # vendor: { id: vendor.id, interface_id: vendor.id + 10000 },
      id: entity.id,
      interface_id: entity.id + 10000
    }
  end
  let(:states) { [] }
  let(:state_manager) { spy(:state_manager) }

  let(:response_handler) do
    Interface::EntityResponseHandler.new(entity, state_manager)
  end

  describe '#call' do
    subject { response_handler.call(response) }

    it { expect { subject }.to_not raise_error }
  end

  context 'when all data is new' do
    before do
      allow(state_manager)
        .to receive(:exist?)
        .and_return(false)
    end
    describe Interface::StateManager do
      it 'should call add state for each item' do
        expect(state_manager).to receive(:add).exactly(4).times

        response_handler.call(response)
      end
    end
  end

  context 'when there is one new state' do
    before do
      allow(state_manager)
        .to receive(:exist?)
        .with(entity)
        .and_return(true)
      allow(state_manager)
        .to receive(:exist?)
        .with(customer)
        .and_return(true)
      allow(state_manager)
        .to receive(:exist?)
        .with(contacts[0])
        .and_return(true)
      allow(state_manager)
        .to receive(:exist?)
        .with(contacts[1])
        .and_return(false)
      allow(state_manager)
        .to receive(:exist?)
        .with(locations[0])
        .and_return(true)
      allow(state_manager)
        .to receive(:update_version)
        .and_return(double(:state))
    end
    let(:contacts) { build_stubbed_list(:contact, 2, entity: entity) }

    describe Interface::StateManager do
      it 'should call update state for the existing items' do
        expect(state_manager).to receive(:update_version).exactly(4).times

        response_handler.call(response)
      end

      it 'should call add state for the new item' do
        expect(state_manager).to receive(:add).exactly(1).times

        response_handler.call(response)
      end
    end
  end
end
