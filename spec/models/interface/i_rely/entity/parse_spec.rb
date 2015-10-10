require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Parse,
               type: :model do
  before do
    allow(customer).to receive(:entity).and_return(entity)
  end
  let(:context) do
    Interface::ObjectContext.new(entity, organization, graph)
  end
  let(:entity) do
    stubbed = build_stubbed(:entity)
    allow(stubbed).to receive(:contacts).and_return([contact])
    allow(stubbed).to receive(:locations).and_return([location])
    allow(stubbed).to receive(:customer).and_return(customer)
    stubbed
  end
  let(:contact) do
    stubbed = build_stubbed(:contact)
    allow(stubbed).to receive(:interface_object_maps).and_return([])
    stubbed
  end
  let(:customer) do
    stubbed = build_stubbed(:customer)
    allow(stubbed).to receive(:interface_object_maps).and_return([])
    stubbed
  end
  let(:location) do
    stubbed = build_stubbed(:location, location_name: Faker::Company.name)
    allow(stubbed).to receive(:interface_object_maps).and_return([])
    stubbed
  end
  let(:graph) { { contacts: nil, locations: nil, customer: nil } }
  let(:organization) { build(:organization) }
  let(:response) do
    {
      data: [
        {
          name: entity.name,
          contacts: [
            {
              name: contact.full_name,
              id: contact.id,
              i21_id: rand(1001..2000)
            }
          ],
          locations: [
            {
              name: location.location_name,
              id: location.id,
              i21_id: rand(2001..3000)
            }
          ],
          customer: {
            i21_id: rand(3001..4000)
          },
          id: entity.id,
          i21_id: rand(1..1000)
        }
      ]
    }
  end

  describe '#call' do
    let(:call) { parse.call }
    let(:parse) { Interface::IRely::Entity::Parse.new(context, response) }

    context 'when an object map exists' do
      before do
        entity._v = 2
        allow(entity)
          .to receive(:interface_object_maps)
          .and_return([object_map])
      end
      let(:object_map) do
        Interface::ObjectMap.new(
          interfaceable: entity,
          integration: organization.integration,
          organization: organization,
          version: 1)
      end
      let!(:original_object_map) { object_map.dup }

      describe '#context.object_map' do
        subject { call.context.object_map }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:i21_id].to_s
        end
        its(:version) { is_expected.to eq entity._v }
        its(:version) { is_expected.to_not eq original_object_map.version }
      end

      describe '#context.child_contexts[:contacts][0].object_map' do
        subject { call.context.child_contexts[:contacts][0].object_map }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:contacts][0][:i21_id].to_s
        end
      end

      describe '#context.child_contexts[:locations][0].object_map' do
        subject { call.context.child_contexts[:locations][0].object_map }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:locations][0][:i21_id].to_s
        end
      end
    end

    context 'when an object map does not exist' do
      let(:entity) do
        stubbed = build_stubbed(:entity, _v: 1)
        # allow(stubbed).to receive(:contacts).and_return([:contact])
        # allow(stubbed).to receive(:locations).and_return([:location])
        # allow(stubbed).to receive(:customer).and_return(:customer)
        stubbed
      end

      describe '#context.object_map' do
        subject { call.context.object_map }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:i21_id].to_s
        end
        its(:version) { is_expected.to eq contact._v }
      end
    end
  end
end
