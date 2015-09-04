require 'rails_helper'

RSpec.describe Interface::EntityRequestGenerator, type: :interactor do
  before do
    allow(entity).to receive(:customer).and_return(customer)
    allow(entity).to receive(:contacts).and_return(contacts)
    allow(entity).to receive(:locations).and_return(locations)
  end
  let(:integration) { build_stubbed(:integration, integration_type: 'test') }
  let(:organization) { build_stubbed(:organization, integration: integration) }
  let(:contacts) { build_stubbed_list(:contact, 1, entity: entity) }
  let(:customer) { build_stubbed(:customer, entity: entity) }
  let(:locations) { build_stubbed_list(:location, 1, entity: entity) }
  let(:entity) { build_stubbed(:entity, _v: 1) }
  let(:call) do
    Interface::EntityRequestGenerator.call(entity: entity,
                                           state_manager: state_manager)
  end
  let(:state_manager) { Interface::StateManager.new(organization, states) }

  context 'when the entity has no state' do
    let(:states) { [] }

    describe '.call' do
      subject { call }

      its(:success?) { is_expected.to be true }
      its(:request) { is_expected.to be_present }

      describe '#request' do
        subject { call.request }

        its([:name]) { is_expected.to eq(entity.name) }
        its([:interface_id]) { is_expected.to be nil }

        describe '[:contacts][0]' do
          subject { call.request[:contacts][0] }

          its([:name]) { is_expected.to eq(contacts[0].full_name) }
          its([:phone_number]) { is_expected.to eq(contacts[0].phone_number) }
          its([:fax_number]) { is_expected.to eq(contacts[0].fax_number) }
          its([:mobile_number]) { is_expected.to eq(contacts[0].mobile_number) }
          its([:email_address]) { is_expected.to eq(contacts[0].email_address) }
          its([:interface_id]) { is_expected.to be nil }
        end

        describe '[:locations][0]' do
          subject { call.request[:locations][0] }

          its([:name]) { is_expected.to eq(locations[0].location_name) }
          its([:street_address]) do
            is_expected.to eq(locations[0].street_address)
          end
          its([:city]) { is_expected.to eq(locations[0].city) }
          its([:region]) { is_expected.to eq(locations[0].region) }
          its([:region_code]) { is_expected.to eq(locations[0].region_code) }
          its([:country]) { is_expected.to eq(locations[0].country) }
          its([:phone_number]) { is_expected.to eq(locations[0].phone_number) }
          its([:fax_number]) { is_expected.to eq(locations[0].fax_number) }
          its([:interface_id]) { is_expected.to be nil }
        end
      end
    end
  end

  context 'when the entity has state' do
    let(:states) do
      [
        Interface::State.new(
            interfaceable: entity,
            interface_id: 10000 + entity.id,
            organization: organization,
            integration: integration,
            version: 1),
        Interface::State.new(
            interfaceable: contacts[0],
            interface_id: 10000 + contacts[0].id,
            organization: organization,
            integration: integration,
            version: 1),
        Interface::State.new(
            interfaceable: locations[0],
            interface_id: 10000 + locations[0].id,
            organization: organization,
            integration: integration,
            version: 1)
      ]
    end

    describe Interactor::Context do
      subject { call }

      its(:success?) { is_expected.to be true }
      its(:request) { is_expected.to be_present }

      describe '#request' do
        subject { call.request }

        its([:interface_id]) { is_expected.to be states[0].interface_id }

        describe '[:contacts][0]' do
          subject { call.request[:contacts][0] }

          its([:interface_id]) { is_expected.to be states[1].interface_id }
        end

        describe '[:locations][0]' do
          subject { call.request[:locations][0] }

          its([:interface_id]) { is_expected.to be states[2].interface_id }
        end
      end
    end
  end

  context 'when an entity contact has no state' do
    let(:contacts) { build_stubbed_list(:contact, 2, entity: entity) }
    let(:states) do
      [
        Interface::State.new(
            interfaceable: entity,
            interface_id: 10000 + entity.id,
            organization: organization,
            integration: integration,
            version: 1),
        Interface::State.new(
            interfaceable: contacts[0],
            interface_id: 10000 + contacts[0].id,
            organization: organization,
            integration: integration,
            version: 1),
        Interface::State.new(
            interfaceable: locations[0],
            interface_id: 10000 + locations[0].id,
            organization: organization,
            integration: integration,
            version: 1)
      ]
    end

    describe Interactor::Context do
      subject { call }

      its(:success?) { is_expected.to be true }
      its(:request) { is_expected.to be_present }

      describe '#request' do
        subject { call.request }

        its([:interface_id]) { is_expected.to be states[0].interface_id }

        describe '[:contacts][0]' do
          subject { call.request[:contacts][0] }

          its([:interface_id]) { is_expected.to be states[1].interface_id }
        end

        describe '[:contacts][1]' do
          subject { call.request[:contacts][1] }

          its([:interface_id]) { is_expected.to be nil }
        end

        describe '[:locations][0]' do
          subject { call.request[:locations][0] }

          its([:interface_id]) { is_expected.to be states[2].interface_id }
        end
      end
    end
  end
end
