require 'rails_helper'

RSpec.describe Interface::ProcessCustomerOrganizationsUpsert,
               type: :interactor, ignore: true do
  before do
    allow(entity)
      .to receive(:organizations)
      .with('customer')
      .and_return(organizations)
    allow(entity)
      .to receive(:customer)
      .and_return(customer)
    allow(Entity).to receive(:find) { entity }
    allow(Interface::CustomerUpsert)
      .to receive(:call)
      .and_return(context)
  end
  let(:context) do
    double(:context,
           interface_log: nil,
           interface_state: nil)
  end
  let(:customer) { build_stubbed(:customer, entity: entity) }
  let(:entity) { build_stubbed(:entity) }
  let(:integration) { build_stubbed(:integration, integration_type: 'Test') }
  let(:organizations) do
    [build_stubbed(:organization, integration: integration)]
  end
  let(:result) do
    Interface::ProcessCustomerOrganizationsUpsert.call(
      entity_id: entity.id, version: customer._v)
  end

  context 'when the entity is not a customer' do
    pending 'check that the entity has a customer trait'
  end

  context 'when the customer is not mapped to an organization' do
    let(:organizations) { [] }

    describe Interactor::Context do
      subject { result }

      it { is_expected.to_not be_success }
      its(:message) do
        is_expected
          .to eq(I18n.t('failure.no_organization',
                        scope: 'process_customer_organizations_upsert'))
      end
    end

    describe Interface::State do
      subject { result.interface_states }

      it { is_expected.to be_empty }
    end

    describe Interface::Log do
      subject { result.interface_logs[0] }

      it { is_expected.to be_present }
      its(:action) { is_expected.to eq :skipped }
      its(:status) { is_expected.to eq :failure }
      its(:message) do
        is_expected
          .to eq(I18n.t('log.message.no_organization',
                        scope: 'process_customer_organizations_upsert'))
      end
      its(:version) { is_expected.to eq(entity.customer._v) }
    end
  end

  context 'when the customer is mapped to one organization' do
    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected
          .to eq(I18n.t('process_customer_organizations_upsert.success'))
      end
    end

    describe Interface::State do
      subject { result.interface_states }

      its(:length) { is_expected.to eq 1 }
    end

    describe Interface::Log do
      subject { result.interface_logs }

      its(:length) { is_expected.to eq 1 }
    end

    describe Interface::CustomerUpsert do
      it do
        result
        expect(Interface::CustomerUpsert).to have_received(:call).once
      end
    end
  end

  context 'when the customer is mapped to two organizations' do
    let(:organizations) do
      [
        build_stubbed(:organization, integration: integration),
        build_stubbed(:organization, integration: integration)
      ]
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected
          .to eq(I18n.t('process_customer_organizations_upsert.success'))
      end
    end

    describe Interface::State do
      subject { result.interface_states }

      its(:length) { is_expected.to eq 2 }
    end

    describe Interface::Log do
      subject { result.interface_logs }

      its(:length) { is_expected.to eq 2 }
    end

    describe Interface::CustomerUpsert do
      it do
        result
        expect(Interface::CustomerUpsert).to have_received(:call).twice
      end
    end
  end
end
