require 'rails_helper'
require_relative 'test_interfaces'

RSpec.describe Interface::CustomerUpdate, type: :interactor do
  before do
    allow(log).to receive(:save!)
    allow(entity)
      .to receive(:customer)
      .and_return(customer)
    allow(Interface::Log).to receive(:new) { log }
  end
  let(:customer) { build_stubbed(:customer, entity: entity) }
  let(:entity) { build_stubbed(:entity) }
  let(:integration) { build_stubbed(:integration, integration_type: 'test') }
  let(:log) { Interface::Log.new }
  let(:result) do
    Interface::CustomerUpdate.call(entity: entity,
                                   integration: integration,
                                   interface_identifier: 1)
  end

  context 'when the update is successful' do
    before do
      allow(Interface::Test::EntityUpdate)
        .to receive(:call)
        .and_return(interface_result)
    end
    let(:interface_result) do
      Interactor::Context.new(
        identifier: 1,
        result: 'success',
        payload: { result: 'success', id: 1 },
        message: I18n.t('test_interfaces.entity_update.success'))
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:identifier) do
        is_expected.to eq interface_result.identifier
      end
      its(:result) do
        is_expected.to eq interface_result.result
      end
      its(:payload) do
        is_expected.to eq interface_result.payload
      end
      its(:message) do
        is_expected.to eq(I18n.t('customer_update.success'))
      end
    end

    describe Interface::Log do
      subject { result.interface_log }

      it { is_expected.to be_present }
      # its(:organization) { is_expected.to eq entity.organization }
      its(:integration) { is_expected.to eq integration }
      its(:interfaceable) { is_expected.to eq entity.customer }
      its(:action) { is_expected.to eq :update }
      its(:status) { is_expected.to eq :success }
      its(:interface_payload) do
        is_expected.to eq({ result: 'success', id: 1 }.to_json)
      end
      its(:interface_status) { is_expected.to eq 'success' }
      its(:message) do
        is_expected.to eq I18n.t('test_interfaces.entity_update.success')
      end
      its(:version) { is_expected.to eq entity.customer._v }
    end

    describe Interface::Test::EntityUpdate do
      it do
        result
        expect(Interface::Test::EntityUpdate).to have_received(:call)
      end
    end
  end
end
