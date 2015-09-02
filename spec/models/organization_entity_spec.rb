require 'rails_helper'

RSpec.describe OrganizationEntity, type: :model do
  it { is_expected.to belong_to(:entity) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to validate_presence_of(:entity_id) }
  it { is_expected.to validate_presence_of(:organization_id) }
  it { is_expected.to validate_presence_of(:uuid) }

  describe 'not stubbed ' do
    subject do
      build(:organization_entity,
            entity: build(:customer).entity, trait: 'customer')
    end

    it do
      is_expected
        .to validate_uniqueness_of(:entity_id)
        .scoped_to(:organization_id, :trait, :deleted_at)
    end
    it { is_expected.to validate_uniqueness_of(:uuid) }
  end

  describe 'after_commit' do
    before do
      subject.run_callbacks(:commit)
    end
    subject { organization_entity }
    let(:organization_entity) do
      create(:organization_entity,
             entity: create(:customer).entity,
             trait: 'customer')
    end

    it do
      expect(EntityUpsertWorker)
        .to have_enqueued_job(organization_entity.entity.id,
                              organization_entity.entity._v)
    end
  end

end
