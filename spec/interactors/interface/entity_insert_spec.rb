require 'rails_helper'
require_relative 'test_interfaces'

RSpec.describe Interface::EntityInsert, type: :interactor do
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
    Interface::EntityInsert.call(entity: entity, integration: integration)
  end

  context 'when the insert is successful' do
    before do
      allow(Interface::Test::EntityInsert)
        .to receive(:call)
        .and_return(interface_result)
    end
    let(:interface_result) do
      Interactor::Context.new(
        identifier: 1,
        result: 'success',
        response: { result: 'success', data: [{ id: 1, x_id: 1 }] }.to_json,
        payload: { result: 'success', data: [{ id: 1, vendor_id: 1 }] },
        message: I18n.t('test_interfaces.entity_insert.success'))
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
      its(:response) do
        is_expected.to eq interface_result.response
      end
      its(:payload) do
        is_expected.to eq interface_result.payload
      end
      its(:message) do
        is_expected.to eq(I18n.t('entity_insert.success'))
      end
    end

    describe Interface::Log do
      subject { result.log }

      it { is_expected.to be_present }
      its(:integration) { is_expected.to eq integration }
      its(:interfaceable) { is_expected.to eq entity }
      its(:action) { is_expected.to eq :insert }
      its(:status) { is_expected.to eq :success }
      its(:interface_payload) do
        is_expected.to eq(interface_result.response)
      end
      its(:interface_status) { is_expected.to eq 'success' }
      its(:message) do
        is_expected.to eq I18n.t('test_interfaces.entity_insert.success')
      end
      its(:version) { is_expected.to eq entity._v }
    end

    describe Interface::Test::EntityInsert do
      it do
        result
        expect(Interface::Test::EntityInsert).to have_received(:call)
      end
    end
  end
end
