require 'rails_helper'

RSpec.describe Interface::IRely::Contact::Parse,
               type: :model do

  let(:payload) { build(:contact_payload) }
  let(:response) do
    {
      data: [
        {
          # name: payload.name,
          contacts: [
            {
              name: payload.full_name,
              id: payload.id,
              i21_id: rand(1001..2000)
            }
          ],
          # id: payload.id,
          # i21_id: rand(1..1000)
        }
      ]
    }
  end

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Contact::Parse.new(payload, response) }

    describe '.payload' do
      subject { call.payload }

      its(:interface_id) do
        is_expected.to eq response[:data][0][:contacts][0][:i21_id]
      end

      describe 'contacts[0]' do
        subject { payload.contacts[0] }

        its(:interface_id) do
          is_expected.to eq response[:data][0][:contacts][0][:i21_id]
        end
      end
    end
  end
end
