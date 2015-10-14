require 'rails_helper'

RSpec.describe Interface::Entity::Upsert, type: :model do
  describe '#call' do
    let(:entity) do
      double(:entity, contacts: [], locations: [], customer: [], save!: true)
    end
    let(:interface) { spy }
    let(:organization) { double(:organization) }
    let(:model) do
      allow(Interface::InterfaceFactory)
        .to receive(:build).and_return(interface)

      Interface::Entity::Upsert.new(entity, organization)
    end
    subject { model.call }

    it 'should call the interface' do
      subject

      expect(interface).to have_received(:call)
    end

    it 'should persist the entity' do
      subject

      expect(entity).to have_received(:save!)
    end
  end
end
