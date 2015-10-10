require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Translate,
               type: :model do
  before do
    allow(customer).to receive(:entity).and_return(entity)
  end
  let(:context) do
    Interface::ObjectContext.new(entity, organization, graph)
  end
  let(:entity) do
    stub_data = attributes_for(:entity, id: 1)
    stub_data[:contacts] = [contact]
    stub_data[:locations] = [location]
    stub_data[:customer] = customer
    stub_data[:interface_object_maps] = []
    double(Entity, stub_data)
  end
  let(:contact) do
    stub_data = attributes_for(:contact, id: 1)
    stub_data[:interface_object_maps] = []
    double(Contact, stub_data)
  end
  let(:customer) do
    stub_data = attributes_for(:customer, id: 1)
    stub_data[:interface_object_maps] = []
    double(Customer, stub_data)
  end
  let(:location) do
    stub_data = attributes_for(:location,
                               id: 1,
                               location_name: Faker::Company.name)
    stub_data[:interface_object_maps] = []
    double(Location, stub_data)
  end
  let(:graph) { { contacts: nil, locations: nil, customer: nil } }
  let(:organization) { build(:organization) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Entity::Translate.new(context) }

    describe '.output' do
      subject { call.output }

      its([:name]) { is_expected.to eq entity.name }
      its([:entityNo]) { is_expected.to eq entity.reference }
      its([:contacts]) { is_expected.to_not be_empty }
      its([:customer]) { is_expected.to_not be_empty }
      its([:locations]) { is_expected.to_not be_empty }

      context 'when the object has no interface_id' do
        its([:id]) { is_expected.to eq entity.id }
        its([:interface_id]) { is_expected.to be nil }
        # its([:rowState]) { is_expected.to eq 'Added' }
      end

      context 'when the object has an interface_id' do
        before do
          allow(entity)
            .to receive(:interface_object_maps)
            .and_return(maps)
        end
        let(:maps) do
          [double(:map,
                  organization: organization,
                  id: entity.id,
                  interface_id: 1)]
        end

        its([:id]) { is_expected.to eq entity.id }
        its([:i21_id]) { is_expected.to eq maps[0].interface_id }
        # its([:rowState]) { is_expected.to eq 'Modified' }
      end
    end
  end

  describe '#translate' do
    let(:translate) do
      allow(Interface::IRely::Entity::Translate)
        .to receive(:new)
        .and_return(spy)

      Interface::IRely::Entity::Translate.translate(context)
    end
    subject { translate }

    context 'when there is one item to translate' do
      let(:context) { double }

      its(:size) { is_expected.to eq 1 }
      it 'should build one translation' do
        subject

        expect(Interface::IRely::Entity::Translate)
          .to have_received(:new).once
      end
    end

    context 'when there is more than one item to translate' do
      let(:context) { [double, double] }

      its(:size) { is_expected.to eq context.size }
      it 'should build the same number of translations as items' do
        subject

        expect(Interface::IRely::Entity::Translate)
          .to have_received(:new).exactly(context.size).times
      end
    end
  end
end
