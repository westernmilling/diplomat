require 'rails_helper'
require_relative 'test_interfaces'

RSpec.describe Interface::CustomerUpsert, type: :interactor, ignore: true do
  before do
    allow(log).to receive(:save!)
    allow(state).to receive(:save!)
    allow(entity)
      .to receive(:customer)
      .and_return(customer)
    allow(customer)
      .to receive(:interface_states)
      .and_return(existing_states)
    allow(Entity).to receive(:find) { entity }
    allow(Interface::Log).to receive(:new) { log }
    allow(Interface::State).to receive(:new) { state }
  end
  let(:customer) { build_stubbed(:customer, entity: entity) }
  let(:entity) { build_stubbed(:entity) }
  let(:existing_states) { [] }
  let(:integration) { build_stubbed(:integration, integration_type: 'Test') }
  let(:state) { Interface::State.new }
  let(:log) { Interface::Log.new }
  let(:organization) { build_stubbed(:organization, integration: integration) }
  let(:result) do
    Interface::CustomerUpsert.call(entity: entity, organization: organization)
  end

  context 'when a newer customer has already been completed' do
    before do
      allow(Interface::CustomerUpdate).to receive(:call)
    end
    let(:customer) { build_stubbed(:customer, entity: entity, _v: 2) }
    let(:existing_states) do
      state = Interface::State.new(
        count: 3,
        interfaceable: customer,
        organization: organization,
        integration: integration,
        action: :update,
        message: I18n.t('entity_update.success'),
        status: :success,
        version: 3)
      allow(state).to receive(:save).and_return(true)

      [state]
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected.to eq(I18n.t('customer_upsert.success'))
      end
    end

    describe Interface::State do
      subject { result.interface_state }

      it { is_expected.to be_present }
      its(:interfaceable) { is_expected.to eq entity.customer }
      its(:action) { is_expected.to eq :update }
      its(:count) { is_expected.to eq existing_states[0].count }
      its(:status) { is_expected.to eq :success }
      its(:message) do
        is_expected.to eq I18n.t('entity_update.success')
      end
      its(:version) { is_expected.to eq existing_states[0].version }
    end

    describe Interface::Log do
      subject { result.interface_log }

      it { is_expected.to be_present }
      its(:interfaceable) { is_expected.to eq entity.customer }
      its(:action) { is_expected.to eq :skipped }
      its(:status) { is_expected.to eq :success }
      its(:interface_payload) { is_expected.to be_nil }
      its(:interface_status) { is_expected.to be_nil }
      its(:message) do
        is_expected.to eq I18n.t('customer_upsert.log.message.old_version')
      end
      its(:version) { is_expected.to eq entity.customer._v }
    end

    describe Interface::CustomerUpdate do
      it do
        result
        expect(Interface::CustomerUpdate).to_not have_received(:call)
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
      allow(Interface::CustomerUpdate)
        .to receive(:call)
        .and_return(context)
    end
    let(:customer) { build_stubbed(:customer, entity: entity, _v: 2) }
    let(:existing_states) do
      state = Interface::State.new(
        count: 1,
        interfaceable: customer,
        organization: organization,
        integration: integration,
        action: :update,
        message: I18n.t('entity_insert.success'),
        status: :success,
        version: 1)
      allow(state).to receive(:save).and_return(true)

      [state]
    end
    let(:log) do
      Interface::Log.new(
        action: :update,
        status: :success,
        message: I18n.t('entity_update.success'),
        version: 2
      )
    end
    let(:context) do
      Interactor::Context.new(
        interface_log: log,
        interface_identifier: entity.id,
        interface_status: 'success',
        interface_payload: { result: 'success', id: entity.id },
        message: I18n.t('entity_update.success'))
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected.to eq(I18n.t('customer_upsert.success'))
      end
    end

    describe Interface::State do
      subject { result.interface_state }

      it { is_expected.to be_present }
      its(:interfaceable) { is_expected.to eq entity.customer }
      its(:action) { is_expected.to eq :update }
      it 'increases the state count by 1' do
        expect { result }.to change { existing_states[0].count }.by(1)
      end
      its(:status) { is_expected.to eq :success }
      its(:message) { is_expected.to eq I18n.t('entity_update.success') }
      its(:version) { is_expected.to eq entity.customer._v }
    end

    describe Interface::Log do
      subject { result.interface_log }

      it { is_expected.to be_present }
      its(:organization) { is_expected.to eq organization }
    end

    describe Interface::CustomerUpdate do
      before { result }

      it { expect(Interface::CustomerUpdate).to have_received(:call) }
    end
  end

  context 'when the customer has not been processed before' do
    before do
      allow(Interface::CustomerInsert)
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
        interface_log: log,
        status: 'success',
        payload: { result: 'success', id: entity.id },
        message: I18n.t('entity_insert.success'))
    end
    let(:existing_states) { [] }

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected.to eq(I18n.t('customer_upsert.success'))
      end
    end

    describe Interface::State do
      subject { result.interface_state }

      it { is_expected.to be_present }
      its(:interface_identifier) do
        is_expected.to eq context.interface_identifier
      end
      its(:interfaceable) { is_expected.to eq entity.customer }
      its(:action) { is_expected.to eq :insert }
      its(:count) { is_expected.to eq 1 }
      its(:status) { is_expected.to eq :success }
      its(:message) do
        is_expected.to eq I18n.t('entity_insert.success')
      end
      its(:version) { is_expected.to eq entity.customer._v }
    end

    describe Interface::Log do
      subject { result.interface_log }

      it { is_expected.to be_present }
      its(:organization) { is_expected.to eq organization }
    end

    describe Interface::CustomerInsert do
      before { result }

      it { expect(Interface::CustomerInsert).to have_received(:call) }
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
end
