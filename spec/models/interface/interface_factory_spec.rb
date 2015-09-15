require 'rails_helper'

RSpec.describe Interface::InterfaceFactory, type: :model do
  describe '.build' do
    before do
      allow(Interface::Adhesive)
        .to receive(:find_by)
        .with(interfaceable: entity, organization: organization)
        .and_return(adhesive)
    end
    let(:context) { double(object: entity, organization: organization) }
    let(:organization) { double() }
    subject { Interface::InterfaceFactory.build(context) }

    context 'when the entity is an old version' do
      let(:adhesive) { double(:adhesive, version: entity._v + 1) }
      let(:entity) { double(_v: 1) }

      it { is_expected.to be_kind_of Interface::IgnoreOldVersion }
    end

    context 'when the entity is new' do
      let(:adhesive) { nil }
      let(:entity) { build_stubbed(:entity, _v: 1) }

      it { is_expected.to be_kind_of Interface::Entity::Insert }
    end

    context 'when the entity is a newer version' do
      let(:adhesive) { double(:adhesive, version: 1) }
      let(:entity) { build_stubbed(:entity, _v: adhesive.version + 1) }

      it { is_expected.to be_kind_of Interface::Entity::Update }
    end
  end
end
