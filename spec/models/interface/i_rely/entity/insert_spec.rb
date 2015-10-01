require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Insert, type: :model do
  describe '.call' do
    let(:credentials) do
      "#{Figaro.env.IRELY_API_KEY}:#{Figaro.env.IRELY_API_SECRET}" + \
        "@#{Figaro.env.IRELY_COMPANY}"
    end
    let(:api) do
      Interface::IRely::Entity::Insert.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        data
      )
    end
    let(:data) do
      {}
    end
    let(:result) do
      # result = nil
      VCR.use_cassette(cassette) do
        # result = api.call
        return api.call
      end
      # result
    end
    # subject { call }

    context 'when the credentials are invalid' do
      let(:cassette) { 'irely_entity_insert_invalid_credentials' }
      let(:credentials) { nil }

      it do
        expect(result[:success]).to eq 'failure'
      end
      # pending 'the api call should fail and return a failure'
    end
  end
end
