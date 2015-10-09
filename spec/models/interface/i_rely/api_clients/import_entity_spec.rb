require 'rails_helper'

RSpec.describe Interface::IRely::ApiClients::ImportEntity,
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
    let(:data) { nil }
    let(:result) { api_client.call }

    context 'when the credentials are invalid' do
      let(:credentials) { nil }

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

    context 'when inserting a valid entity' do
      let(:data) do
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

      subject { result }

      its (:success) { is_expected.to be true }
    end

    context 'when inserting an invalid entity' do
      let(:data) do
        [
          {
            id: Time.now.utc.to_i,
            reference: Time.now.utc.to_i,
            name: Faker::Company.name,
            contacts: [],
            locations: [],
            customer: {}
          }
        ]
      end

      subject { result }

      its(:success) { is_expected.to be false }
    end
  end
end
