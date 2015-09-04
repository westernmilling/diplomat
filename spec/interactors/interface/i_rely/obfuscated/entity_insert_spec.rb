require 'rails_helper'

RSpec.describe Interface::IRely::Obfuscated::EntityInsert,
               type: :interactor, vcr: true do
  describe '.call' do
    let(:credentials) do
      "#{Figaro.env.IRELY_API_KEY}/#{Figaro.env.IRELY_API_SECRET}" + \
      "@#{Figaro.env.IRELY_COMPANY}"
    end
    let(:call) do
      result = nil
      VCR.use_cassette(cassette) do
        result = Interface::IRely::Obfuscated::EntityInsert.call(
          base_url: Figaro.env.IRELY_BASE_URL,
          credentials: credentials,
          request: request
        )
      end
      result
    end

    context 'when inserting a new customer' do
      let(:cassette) { 'obfuscated_entity_customer' }
      let(:entity_name) { Faker::Company.name }
      let(:request) do
        {
          id: 100001,
          name: entity_name,
          entity_type: %w{company person}.sample,
          customer: {
            id: 100001,
            credit_limit: 0
          },
          contacts: [
            {
              id: 100001,
              name: Faker::Name.name,
              phone_number: Faker::PhoneNumber.phone_number,
              fax_number: Faker::PhoneNumber.phone_number,
              mobile_number: Faker::PhoneNumber.phone_number,
              email_address: Faker::Internet.email
            }
          ],
          locations: [
            {
              id: 100001,
              name: entity_name,
              street_address: Faker::Address.street_address,
              city: Faker::Address.city,
              region: Faker::Address.state,
              region_code: Faker::Address.zip_code,
              country: 'United States'
            }
          ]
        }
      end
      subject { call }

      it { is_expected.to be_success }
      its(:status) { is_expected.to eq :success }
      its(:response) { is_expected.to be_present }
      its(:payload) { is_expected.to be_present }
      describe 'payload' do
        subject { call.payload }

        its([:data]) { is_expected.to be_present }
      end
      describe 'payload[data][0]' do
        subject { call.payload[:data][0] }

        its([:name]) { is_expected.to be_present }
        its([:interface_id]) { is_expected.to be_present }
        its([:i21_id]) { is_expected.to_not be_present }
      end
    end
  end
end
