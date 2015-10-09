require 'rails_helper'

Interface::ObjectContextX = Struct.new(:children,
                                       :graph,
                                       :organization,
                                       :root_object) do
  def initialize(object, organization, graph = nil)
    self.children = {}
    self.root_object = object
    self.organization = organization
    self.graph = graph
    self.graph.each do |k, v|
      self.children[k] = build(object.send(k), v)
    end if self.graph
  end

  def build(item, graph)
    if item.respond_to?(:each)
      item.map { |x| build_one(x, graph) }
    else
      build_one(item, graph)
    end
  end

  def build_one(item, graph)
    Interface::ObjectContextX
      .new(item, self.organization, graph)
  end

  def object_map
    @object_map ||= object
      .interface_object_maps
      .select { |x| x.organization == organization }
      .first
  end
end

RSpec.describe Interface::ObjectContext, type: :model do
  describe '.new' do
    let(:context) do
      Interface::ObjectContextX.new(object, organization, graph)
    end
    let(:object) do
      build(:entity) do |entity|
        entity.contacts << build(:contact, entity: entity)
      end
    end
    let(:organization) { build(:organization) }
    let(:graph) do
      {
        contacts: nil, customer: nil
      }
    end

    subject { context }

    its(:graph) { is_expected.to eq graph }
    describe '#root_object' do
      subject { context.root_object }

      it { is_expected.to be_present }
      it { is_expected.to be_kind_of(Entity) }
    end
    describe '#children' do
      subject { context.children }

      its([:contacts]) { is_expected.to_not be_nil }
      its([:contacts]) { is_expected.to be_kind_of(Enumerable) }
      its([:customer]) { is_expected.to be_present }
      its([:customer]) { is_expected.to be_kind_of(Interface::ObjectContextX) }
    end
    describe '#children[:contacts][0]' do
      subject { context.children[:contacts][0] }

      its(:root_object) { is_expected.to be_kind_of(Contact) }
    end
  end
end
