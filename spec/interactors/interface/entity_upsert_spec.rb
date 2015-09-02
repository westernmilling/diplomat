require 'rails_helper'
require_relative 'test_interfaces'

RSpec.describe Interface::EntityUpsert, type: :interactor do
  before do
    allow(log).to receive(:save!)
    allow(state_manager).to receive(:persist!)

    allow(Entity).to receive(:find) { entity }
    allow(Interface::Log).to receive(:new) { log }
  end
  let(:entity) do
    temp_entity = build_stubbed(:entity, _v: version)
    allow(temp_entity).to receive(:customer).and_return(build_stubbed(:customer))
    allow(temp_entity).to receive(:contacts).and_return(build_stubbed_list(:contact, 1))
    allow(temp_entity).to receive(:locations).and_return(build_stubbed_list(:location, 1))
    temp_entity
  end
  let(:integration) { build_stubbed(:integration, integration_type: 'test') }
  let(:log) { Interface::Log.new }
  let(:organization) { build_stubbed(:organization, integration: integration) }
  let(:state_manager) { Interface::StateManager.new(organization, states) }
  let(:states) { [] }
  let(:version) { 1 }
  let(:result) do
    Interface::EntityUpsert.call(entity: entity,
                                 organization: organization,
                                 state_manager: state_manager)
  end

  context 'when a newer customer has already been completed' do
    before do
      allow(Interface::EntityUpdate).to receive(:call)
    end
    let(:states) do
      [
        Interface::State.new(
            count: 3,
            interfaceable: entity,
            organization: organization,
            integration: integration,
            message: I18n.t('entity_update.success'),
            status: :success,
            version: 3)
      ]
    end
    let(:version) { 2 }

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected.to eq(I18n.t('entity_upsert.success'))
      end
    end

    describe Interface::State do
      subject { result.states[0] }

      it { is_expected.to be_present }
      its(:interfaceable) { is_expected.to eq entity }
      its(:count) { is_expected.to eq states[0].count }
      its(:status) { is_expected.to eq :success }
      # its(:message) { is_expected.to eq I18n.t('entity_update.success') }
      its(:version) { is_expected.to eq states[0].version }
    end

    describe Interface::Log do
      subject { result.log }

      it { is_expected.to be_present }
      its(:interfaceable) { is_expected.to eq entity }
      its(:action) { is_expected.to eq :skipped }
      its(:status) { is_expected.to eq :success }
      its(:interface_payload) { is_expected.to be_nil }
      its(:interface_status) { is_expected.to be_nil }
      its(:message) do
        is_expected.to eq I18n.t('entity_upsert.log.message.old_version')
      end
      its(:version) { is_expected.to eq entity._v }
    end

    describe Interface::EntityUpdate do
      it do
        result
        expect(Interface::EntityUpdate).to_not have_received(:call)
      end
    end
  end

  context 'when a customer of the same version has been completed' do
    pending 'we should ignore and log the reason'
  end

  context 'when the customer has previously failed' do
    pending 'we should continue the upsert and update with success'
  end

  context 'when the customer is a higher version that processed' do
    before do
      allow(Interface::EntityUpdate)
        .to receive(:call)
        .and_return(context)
    end
    let(:states) do
      [
        Interface::State.new(
            count: 1,
            interfaceable: entity,
            organization: organization,
            integration: integration,
            message: I18n.t('entity_insert.success'),
            status: :success,
            version: 1),
        Interface::State.new(
            count: 1,
            interfaceable: entity.contacts[0],
            organization: organization,
            integration: integration,
            message: I18n.t('entity_insert.success'),
            status: :success,
            version: 1),
        Interface::State.new(
            count: 1,
            interfaceable: entity.locations[0],
            organization: organization,
            integration: integration,
            message: I18n.t('entity_insert.success'),
            status: :success,
            version: 1)
      ]
    end
    let(:log) do
      Interface::Log.new(
        action: :update,
        status: :success,
        message: I18n.t('entity_update.success'),
        version: 2
      )
    end
    let(:version) { 2 }
    let(:context) do
      Interactor::Context.new(
        log: log,
        result: 'success',
        payload: {
          data: [
            {
              contacts: entity
                        .contacts
                        .map { |x| { id: x.id, interface_id: 10000 + x.id } },
              locations: entity
                         .locations
                         .map { |x| { id: x.id, interface_id: 10000 + x.id } },
              id: entity.id,
              interface_id: 10000 + entity.id
            }
          ]
        },
        vendor_response: 'this is unimportant as its for debug',
        message: I18n.t('entity_updat.success'))
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected.to eq(I18n.t('entity_upsert.success'))
      end
    end

    describe '#states' do
      describe 'entity state' do
        subject { result.states.detect { |x| x.interfaceable_type == 'Entity' } }

        it { is_expected.to be_present }
        its(:interfaceable) { is_expected.to eq entity }
        its(:count) { is_expected.to eq 2 }
        its(:status) { is_expected.to eq :success }
        its(:interface_identifier) { is_expected.to eq (entity.id + 10000).to_s }
        its(:interface_identifier) { is_expected.to be_present }
        its(:version) { is_expected.to eq 2 }
      end
      describe 'contact state' do
        subject { result.states.detect { |x| x.interfaceable_type == 'Contact' } }

        it { is_expected.to be_present }
        its(:interfaceable) { is_expected.to eq entity.contacts[0] }
        its(:count) { is_expected.to eq 2 }
        its(:status) { is_expected.to eq :success }
        its(:interface_identifier) { is_expected.to eq (entity.contacts[0].id + 10000).to_s }
        its(:version) { is_expected.to eq 1 }
      end
      describe 'location state' do
        subject { result.states.detect { |x| x.interfaceable_type == 'Location' } }

        it { is_expected.to be_present }
        its(:interfaceable) { is_expected.to eq entity.locations[0] }
        its(:count) { is_expected.to eq 2 }
        its(:status) { is_expected.to eq :success }
        its(:interface_identifier) { is_expected.to eq (entity.locations[0].id + 10000).to_s }
        its(:version) { is_expected.to eq 1 }
      end
    end

    describe Interface::Log do
      subject { result.log }

      it { is_expected.to be_present }
      its(:organization) { is_expected.to eq organization }
    end

    describe Interface::EntityUpdate do
      before { result }

      it { expect(Interface::EntityUpdate).to have_received(:call) }
    end
  end

  context 'when the customer has not been processed before' do
    before do
      allow(Interface::EntityInsert)
        .to receive(:call)
        .and_return(context)
    end
    let(:log) do
      Interface::Log.new(
        action: :insert,
        status: :success,
        message: I18n.t('entity_insert.success'),
        version: 1
      )
    end
    let(:context) do
      Interactor::Context.new(
        log: log,
        result: 'success',
        payload: {
          data: [
            {
              contacts: entity
                        .contacts
                        .map { |x| { id: x.id, interface_id: 10000 + x.id } },
              locations: entity
                         .locations
                         .map { |x| { id: x.id, interface_id: 10000 + x.id } },
              id: entity.id,
              interface_id: 10000 + entity.id
            }
          ]
        },
        vendor_response: 'this is unimportant as its for debug',
        message: I18n.t('entity_insert.success'))
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) { is_expected.to eq(I18n.t('entity_upsert.success')) }
      its(:status) { is_expected.to eq 'success' }
    end

    describe '#states' do
      describe 'entity state' do
        subject { result.states.detect { |x| x.interfaceable_type == 'Entity' } }

        it { is_expected.to be_present }
        its(:interfaceable) { is_expected.to eq entity }
        its(:count) { is_expected.to eq 1 }
        its(:status) { is_expected.to eq :success }
        its(:interface_identifier) { is_expected.to eq (entity.id + 10000).to_s }
        its(:interface_identifier) { is_expected.to be_present }
        its(:version) { is_expected.to eq 1 }
      end
      describe 'contact state' do
        subject { result.states.detect { |x| x.interfaceable_type == 'Contact' } }

        it { is_expected.to be_present }
        its(:interfaceable) { is_expected.to eq entity.contacts[0] }
        its(:count) { is_expected.to eq 1 }
        its(:status) { is_expected.to eq :success }
        its(:interface_identifier) { is_expected.to eq (entity.contacts[0].id + 10000).to_s }
        its(:version) { is_expected.to eq 1 }
      end
      describe 'location state' do
        subject { result.states.detect { |x| x.interfaceable_type == 'Location' } }

        it { is_expected.to be_present }
        its(:interfaceable) { is_expected.to eq entity.locations[0] }
        its(:count) { is_expected.to eq 1 }
        its(:status) { is_expected.to eq :success }
        its(:interface_identifier) { is_expected.to eq (entity.locations[0].id + 10000).to_s }
        its(:version) { is_expected.to eq 1 }
      end
    end

    describe Interface::StateManager do
      it do
        result

        expect(state_manager).to have_received(:persist!)
      end
    end

    describe Interface::Log do
      subject { result.log }

      it { is_expected.to be_present }
      its(:organization) { is_expected.to eq organization }
    end

    describe Interface::EntityInsert do
      before { result }

      it { expect(Interface::EntityInsert).to have_received(:call) }
    end
  end

  # What about when we try to create a new customer with the same reference
  # as an existing customer, will the ERP error out?

  context 'when the customer was updated after the upsert was queued' do
    # if customer.version > context.version
    pending 'we should skip the upsert request'
  end

  context 'when the integration interface fails' do
    pending 'we should return failure and log accordingly'
  end

  context 'when a contact has been added' do
    pending 'a new contact state should be created and the entity updated'
  end

  context 'when a location has been added' do
    pending 'a new location state should be created and the entity updated'
  end
end
