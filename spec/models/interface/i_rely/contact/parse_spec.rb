require 'rails_helper'

RSpec.describe Interface::IRely::Contact::Parse,
               type: :model do
  let(:context) do
    Interface::ObjectContext.new(contact, organization)
  end
  let(:organization) { build(:organization) }
  let(:response) do
    {
      name: contact.full_name,
      id: contact.id,
      i21_id: rand(1001..2000)
    }
  end

  describe '#call' do
    let(:call) { parse.call }
    let(:parse) { Interface::IRely::Contact::Parse.new(context, response) }

    context 'when an object map exists' do
      before do
        allow(contact)
          .to receive(:interface_object_maps)
          .and_return([object_map])
      end
      let(:contact) do
        build_stubbed(:contact, _v: 2)
      end
      let(:object_map) do
        Interface::ObjectMap.new(
          interfaceable: contact,
          integration: organization.integration,
          organization: organization,
          version: 1)
      end
      let!(:original_object_map) { object_map.dup }

      describe '#context.object_map' do
        subject { call.context.object_map }

        its(:interface_id) { is_expected.to eq response[:i21_id].to_s }
        its(:version) { is_expected.to eq contact._v }
        its(:version) { is_expected.to_not eq original_object_map.version }
      end
    end

    context 'when an object map does not exist' do
      let(:contact) { build_stubbed(:contact) }

      describe '#context.object_map' do
        subject { call.context.object_map }

        its(:interface_id) { is_expected.to eq response[:i21_id].to_s }
        its(:version) { is_expected.to eq contact._v }
      end
    end
  end
end
