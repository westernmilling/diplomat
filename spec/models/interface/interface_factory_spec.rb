require 'rails_helper'
require_relative 'test_object'

RSpec.describe Interface::InterfaceFactory, type: :model do
  describe '.build' do
    let(:context) do
      double(adhesive: adhesive, object: object, organization: organization)
    end
    let(:organization) { double(integration: integration) }
    let(:integration) { double(interface_namespace: Interface::Test) }
    subject { Interface::InterfaceFactory.build(context) }

    context 'when the entity is an old version' do
      let(:adhesive) { double(:adhesive, version: object._v + 1) }
      let(:object) { TestObject.new(_v: 1) }

      it { is_expected.to be_kind_of Interface::IgnoreOldVersion }
    end

    context 'when the entity is new' do
      let(:adhesive) { nil }
      let(:object) { TestObject.new(_v: 1) }

      it { is_expected.to be_kind_of Interface::Test::TestObject::Insert }
    end

    context 'when the entity is existing' do
      let(:adhesive) { double(:adhesive, version: 1) }
      let(:object) { TestObject.new(_v: adhesive.version + 1) }

      it { is_expected.to be_kind_of Interface::Test::TestObject::Update }
    end
  end
end
