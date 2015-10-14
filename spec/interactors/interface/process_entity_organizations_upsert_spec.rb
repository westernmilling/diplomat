require 'rails_helper'

RSpec.describe Interface::ProcessEntityOrganizationsUpsert,
               type: :interactor do

  let(:result) do
    Interface::ProcessEntityOrganizationsUpsert.call(
      entity_id: entity.id, version: entity._v)
  end

  describe 'mocked tests' do
    before do
      allow(entity)
        .to receive(:organizations)
        .and_return(organizations)
      allow(entity)
        .to receive(:save!)
      allow(Entity)
        .to receive(:find) { entity }
      allow(Interface::Entity::Upsert)
        .to receive(:new).and_return(upsert_spy)
    end
    let(:entity) { build_stubbed(:entity) }
    let(:organizations) do
      [build_stubbed(:organization, integration: integration)]
    end
    let(:integration) { build_stubbed(:integration, integration_type: 'Test') }
    let(:upsert_spy) { spy }

    context 'when the entity is not mapped to an organization' do
      let(:organizations) { [] }

      describe Interactor::Context do
        subject { result }

        it { is_expected.to be_success }
      end

      describe Interface::Log do
        before { result }

        subject { entity.interface_logs[0] }

        it { is_expected.to be_present }
        its(:action) { is_expected.to eq :skipped }
        its(:status) { is_expected.to eq :success }
        its(:message) do
          is_expected
            .to eq(I18n.t('failure.no_organization',
                          scope: 'process_entity_organizations_upsert'))
        end
        its(:version) { is_expected.to eq(entity._v) }
      end
    end
    context 'when the entity is mapped to one organization' do
      describe Interactor::Context do
        subject { result }

        it { is_expected.to be_success }
        its(:message) do
          is_expected
            .to eq(I18n.t('process_entity_organizations_upsert.success'))
        end
      end

      describe Interface::Entity::Upsert do
        it do
          result
          expect(upsert_spy).to have_received(:call).once
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
            .to eq(I18n.t('process_entity_organizations_upsert.success'))
        end
      end

      describe Interface::Entity::Upsert do
        it do
          result
          expect(upsert_spy).to have_received(:call).twice
        end
      end
    end
  end

  describe 'integration tests', vcr: true do
    let(:entity) do
      temp = create(:entity, :with_contact)
      temp.customer = create(:customer, entity: temp)
      temp.organization_entities << create(:organization_entity,
                                           organization: organization,
                                           entity: temp,
                                           trait: 'customer')
      temp
    end
    let(:organization) { create(:organization, integration: integration) }
    let(:integration) do
      create(:integration,
             address: Figaro.env.IRELY_BASE_URL,
             credentials: credentials)
    end
    let(:credentials) do
      "#{Figaro.env.IRELY_API_KEY}" \
      + ":#{Figaro.env.IRELY_API_SECRET}" \
      + "@#{Figaro.env.IRELY_COMPANY}"
    end

    describe Interactor::Context do
      subject { result }

      it { is_expected.to be_success }
      its(:message) do
        is_expected
          .to eq(I18n.t('process_entity_organizations_upsert.success'))
      end
    end
    describe 'entity.interface_logs[0]' do
      before { result }

      subject { entity.interface_logs[0] }

      it { is_expected.to be_present }
      its(:action) { is_expected.to eq :insert }
      its(:interfaceable) { is_expected.to eq entity }
      its(:integration) { is_expected.to eq integration }
      its(:message) { is_expected.to_not include('error')  }
      its(:organization) { is_expected.to eq organization }
      its(:status) { is_expected.to eq :success }
      its(:version) { is_expected.to eq(entity._v) }
    end
    describe 'entity.interface_object_maps[0]' do
      before { result }

      subject { entity.interface_object_maps[0] }

      it { is_expected.to be_present }
      its(:interfaceable) { is_expected.to eq entity }
      its(:integration) { is_expected.to eq integration }
      its(:organization) { is_expected.to eq organization }
      its(:version) { is_expected.to eq(entity._v) }
    end
  end
end
