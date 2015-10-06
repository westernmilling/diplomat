require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Parse,
               type: :model do

  let(:payload) do
    build(:entity_payload) do |entity_payload|
      entity_payload.contacts << build(:contact_payload)
      entity_payload.locations << build(:location_payload)
      entity_payload.customer = build(:customer_payload)
    end
  end
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
          locations: [
            {
              name: payload.locations[0].location_name,
              id: payload.locations[0].id,
              i21_id: rand(2001..3000)
            }
          ],
          customer: {
            i21_id: rand(3001..4000)
          },
          id: payload.id,
          i21_id: rand(1..1000)
        }
      ]
    }
  end

  describe '#call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Entity::Parse.new(payload, response) }

    describe 'payload' do
      before { call }
      subject { payload }

      its(:interface_id) { is_expected.to eq response[:data][0][:i21_id] }

      describe '#contacts[0]' do
        subject { payload.contacts[0] }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:contacts][0][:i21_id]
        end
      end

      describe '#locations[0]' do
        subject { payload.locations[0] }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:locations][0][:i21_id]
        end
      end

      # describe '#customer' do
      #   subject { payload.customer }
      #
      #   its(:interface_id) do
      #     is_expected.to eq response[:data][0][:customer][:i21_id]
      #   end
      # end
    end
  end
end
