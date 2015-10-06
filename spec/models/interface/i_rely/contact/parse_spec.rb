require 'rails_helper'

RSpec.describe Interface::IRely::Contact::Parse,
               type: :model do

  let(:payload) { build(:contact_payload) }
  let(:response) do
    {
              name: payload.full_name,
              id: payload.id,
              i21_id: rand(1001..2000)
    }
  end

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Contact::Parse.new(payload, response) }

    describe '.payload' do
      subject { call.payload }

      its(:interface_id) do
        is_expected.to eq response[:i21_id]
      end
    end
  end
end
