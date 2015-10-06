require 'rails_helper'

RSpec.describe Interface::IRely::Location::Parse,
               type: :model do

  let(:payload) { build(:location_payload) }
  let(:response) do
    {
      name: payload.location_name,
      id: payload.id,
      i21_id: rand(2001..3000)
    }
  end

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Location::Parse.new(payload, response) }

    describe '.payload' do
      subject { call.payload }

      its(:interface_id) do
        is_expected.to eq response[:i21_id]
      end
    end
  end
end
