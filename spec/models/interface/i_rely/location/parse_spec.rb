require 'rails_helper'

RSpec.describe Interface::IRely::Location::Parse,
               type: :model do
  let(:context) do
    Interface::ObjectContext.new(location, organization)
  end
  let(:organization) { build(:organization) }
  let(:response) do
    {
      name: location.location_name,
      id: location.id,
      i21_id: rand(2001..3000)
    }
  end

  describe '#call' do
    let(:call) { parse.call }
    let(:parse) { Interface::IRely::Location::Parse.new(context, response) }

    context 'when an object map exists' do
      before do
        allow(location)
          .to receive(:interface_object_maps)
          .and_return([object_map])
      end
      let(:location) do
        build_stubbed(:location, location_name: Faker::Company.name, _v: 2)
      end
      let(:object_map) do
        Interface::ObjectMap.new(
          interfaceable: location,
          integration: organization.integration,
          organization: organization,
          version: 1)
      end
      let!(:original_object_map) { object_map.dup }

      describe '#context.object_map' do
        subject { call.context.object_map }

        its(:interface_id) { is_expected.to eq response[:i21_id].to_s }
        its(:version) { is_expected.to eq location._v }
        its(:version) { is_expected.to_not eq original_object_map.version }
      end
    end

    context 'when an object map does not exist' do
      let(:location) { build_stubbed(:location) }

      describe '#context.object_map' do
        subject { call.context.object_map }

        its(:interface_id) { is_expected.to eq response[:i21_id].to_s }
        its(:version) { is_expected.to eq location._v }
      end
    end
  end
end
