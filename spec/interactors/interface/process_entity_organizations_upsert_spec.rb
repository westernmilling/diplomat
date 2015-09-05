require 'rails_helper'

RSpec.describe Interface::ProcessEntityOrganizationsUpsert,
               type: :interactor do
  before do
    allow(entity)
      .to receive(:organizations)
      .and_return(organizations)
    allow(Entity).to receive(:find) { entity }
    allow(Interface::EntityUpsert)
      .to receive(:call)
      .and_return(context)
  end
  let(:context) do
    double(:context,
           log: nil,
           states: nil)
  end
  let(:entity) { build_stubbed(:entity) }
  let(:integration) { build_stubbed(:integration, integration_type: 'test') }
  let(:organizations) do
    [build_stubbed(:organization, integration: integration)]
  end
  let(:result) do
    Interface::ProcessEntityOrganizationsUpsert.call(
      entity_id: entity.id, version: entity._v)
  end

  context 'when the entity is not mapped to an organization' do
    let(:organizations) { [] }

    describe Interactor::Context do
      subject { result }

      it { is_expected.to_not be_success }
      its(:message) do
        is_expected
          .to eq(I18n.t('failure.no_organization',
                        scope: 'process_entity_organizations_upsert'))
      end
    end

    # describe Interface::State do
    #   subject { result.states }
    #
    #   it { is_expected.to be_empty }
    # end

    describe Interface::Log do
      subject { result.logs[0] }

      it { is_expected.to be_present }
      its(:action) { is_expected.to eq :skipped }
      its(:status) { is_expected.to eq :failure }
      its(:message) do
        is_expected
          .to eq(I18n.t('log.message.no_organization',
                        scope: 'process_entity_organizations_upsert'))
      end
      its(:version) { is_expected.to eq entity._v }
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

    # describe Interface::State do
    #   subject { result.states }
    #
    #   # Entity, Contact, Location
    #   its(:length) { is_expected.to eq 3 }
    # end
    #
    # describe Interface::Log do
    #   subject { result.logs }
    #
    #   its(:length) { is_expected.to eq 1 }
    # end

    describe Interface::EntityUpsert do
      it do
        result
        expect(Interface::EntityUpsert).to have_received(:call).once
      end
    end
  end

  context 'when the entity is mapped to two organizations' do
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

    # Entity, Contact, Location x 2 Organizations
    # describe Interface::State do
    #   subject { result.states }
    #
    #   its(:length) { is_expected.to eq 6 }
    # end
    #
    # describe Interface::Log do
    #   subject { result.logs }
    #
    #   its(:length) { is_expected.to eq 2 }
    # end

    describe Interface::EntityUpsert do
      it do
        result
        expect(Interface::EntityUpsert).to have_received(:call).twice
      end
    end
  end
end
