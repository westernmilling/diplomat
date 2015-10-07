require 'rails_helper'

RSpec.describe Interface::IRely::ApiClient::ImportEntity,
               type: :model, vcr: true do
  describe '.call' do
    let(:credentials) do
      Interface::IRely::Credentials
        .new(Figaro.env.IRELY_API_KEY,
             Figaro.env.IRELY_API_SECRET,
             Figaro.env.IRELY_COMPANY)
    end
    let(:api_client) do
      Interface::IRely::ApiClient::ImportEntity.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        data
      )
    end
    let(:data) { nil }
    let(:result) { api_client.call }

    context 'when the credentials are invalid' do
      let(:credentials) { nil }

      subject { result }

      its([:success]) { is_expected.to be false }
      its([:message]) do
        is_expected.to eq 'Authorization has been denied for this request.'
      end
    end

    context 'when there is no data' do
      let(:data) { nil }

      subject { result }

      its([:success]) { is_expected.to be false }
      its([:message]) do
        is_expected.to eq 'An error has occurred.'
      end
    end

    context 'when inserting a valid entity' do
      let(:data) do
        entity_hash = {
          id: Time.now.utc.to_i,
          reference: Time.now.utc.to_i,
          name: Faker::Company.name,
          contacts: [],
          locations: [],
          customer: {}
        }

        [entity_hash]
      end

      subject { result }

      its([:success]) { is_expected.to be true }
    end

    context 'when inserting an invalid entity' do
      let(:data) do
        {}
      end

      subject { result }

      its([:success]) { is_expected.to be false }
    end
  end
end
