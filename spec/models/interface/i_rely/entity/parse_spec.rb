require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Parse,
               type: :model do

  let(:payload) do
    build(:entity_payload) do |entity_payload|
      entity_payload.contacts << build(:contact_payload)
    end
  end
  # let(:contact_payload) do
  #   build(:contact_payload)
  # end
  let(:response) do
    {
      data: [
        {
          name: payload.name,
          contacts: [
            {
              name: payload.contacts[0].full_name,
              id: payload.contacts[0].id,
              i21_id: rand(1001..2000)
            }
          ],
          id: payload.id,
          i21_id: rand(1..1000)
        }
      ]
    }
  end

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Entity::Parse.new(payload, response) }

    describe '.payload' do
      subject { call.payload }

      its(:interface_id) { is_expected.to eq response[:data][0][:i21_id] }

      describe 'contacts[0]' do
        subject { call.payload.contacts[0] }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:contacts][0][:i21_id]
        end
      end
    end

    # it 'should parse contacts' do
    #   call
    #
    #   expect(Interface::IRely::Contact::Parse)
    #     .to have_received(:parse).exactly(payload.contacts.size).times
    # end
  end
end
