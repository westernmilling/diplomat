require 'rails_helper'

RSpec.describe Interface::IRely::ApiClients::SyncEntity,
               type: :model, vcr: true do
  describe '.call' do
    let(:credentials) do
      Interface::IRely::Credentials
        .new(Figaro.env.IRELY_API_KEY,
             Figaro.env.IRELY_API_SECRET,
             Figaro.env.IRELY_COMPANY)
    end
    let(:api_client) do
      described_class.new(Figaro.env.IRELY_BASE_URL, credentials, data)
    end
    let(:data) do
      # First we insert the entity
      result = Interface::IRely::ApiClients::ImportEntity.new(
        Figaro.env.IRELY_BASE_URL,
        Interface::IRely::Credentials
          .new(Figaro.env.IRELY_API_KEY,
               Figaro.env.IRELY_API_SECRET,
               Figaro.env.IRELY_COMPANY),
        existing_data
      ).call

      # Now we update the original data with the iRely references
      temp_data = existing_data.dup
      temp_data[0][:i21_id] = result.hash_response[:data][0][:i21_id]
      temp_data[0][:contacts][0][:i21_id] =
        result.hash_response[:data][0][:contacts][0][:i21_id]
      temp_data[0][:locations][0][:i21_id] =
        result.hash_response[:data][0][:locations][0][:i21_id]
      temp_data
    end
    let(:existing_data) do
      name = Faker::Company.name
      [
        {
          id: Time.now.utc.to_i,
          entityNo: Time.now.utc.to_i,
          name: name,
          contacts: [
            {
              id: Time.now.utc.to_i,
              name: Faker::Name.name,
              phone: Faker::PhoneNumber.phone_number,
              fax: Faker::PhoneNumber.phone_number,
              mobile: Faker::PhoneNumber.cell_phone,
              email: Faker::Internet.email,
              rowState: 'Added'
            }
          ],
          locations: [
            {
              id: Time.now.utc.to_i,
              name: name,
              phone: Faker::PhoneNumber.phone_number,
              fax: Faker::PhoneNumber.phone_number,
              address: Faker::Address.street_address,
              city: Faker::Address.city,
              state: Faker::Address.state,
              zipcode: Faker::Address.zip_code,
              country: 'United States',
              termsId: 'Due on Receipt',
              rowState: 'Added'
            }
          ],
          customer: {
            creditLimit: 0,
            type: 'Company'
          }
        }
      ]
    end
    let(:result) { api_client.call }

    context 'when the credentials are invalid' do
      let(:credentials) { nil }
      let(:data) { nil }

      subject { result }

      its(:success) { is_expected.to be false }
      its(:message) do
        is_expected.to eq 'Authorization has been denied for this request.'
      end
    end

    context 'when there is no data' do
      let(:data) { nil }

      subject { result }

      its(:success) { is_expected.to be false }
      its(:message) do
        is_expected.to eq 'An error has occurred.'
      end
    end

    context 'when updating a valid entity' do
      subject do
        data[0][:name] = Faker::Company.name

        result
      end

      its (:success) { is_expected.to be true }
    end

    context 'when updating an invalid entity' do
      subject do
        data[0][:name] = nil

        result
      end

      its(:success) { is_expected.to be false }
    end
  end
end
