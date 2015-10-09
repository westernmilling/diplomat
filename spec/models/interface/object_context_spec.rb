require 'rails_helper'

RSpec.describe Interface::ObjectContext, type: :model do
  describe '.new' do
    let(:context) do
      Interface::ObjectContext.new(object, organization, graph)
    end
    let(:object) do
      build(:entity) do |entity|
        entity.contacts << build(:contact, entity: entity)
      end
    end
    let(:organization) { build(:organization) }
    let(:graph) do
      { contacts: nil, customer: nil }
    end

    subject { context }

    its(:graph) { is_expected.to eq graph }
    describe '#root_instance' do
      subject { context.root_instance }

      it { is_expected.to be_present }
      it { is_expected.to be_kind_of(Entity) }
    end
    describe '#child_contexts' do
      subject { context.child_contexts }

      its([:contacts]) { is_expected.to_not be_nil }
      its([:contacts]) { is_expected.to be_kind_of(Enumerable) }
      its([:customer]) { is_expected.to be_present }
      its([:customer]) { is_expected.to be_kind_of(Interface::ObjectContext) }
    end
    describe '#child_contexts[:contacts][0]' do
      subject { context.child_contexts[:contacts][0] }

      its(:root_instance) { is_expected.to be_kind_of(Contact) }
      its(:organization) { is_expected.to eq organization }
    end
  end
end
