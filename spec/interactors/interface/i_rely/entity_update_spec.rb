require 'rails_helper'

RSpec.describe Interface::IRely::EntityUpdate, type: :interactor, vcr: true do
  describe '.call' do
    let(:credentials) do
      "#{Figaro.env.IRELY_API_KEY}:#{Figaro.env.IRELY_API_SECRET}" + \
        "@#{Figaro.env.IRELY_COMPANY}"
    end
    let(:call) do
      result = nil
      VCR.use_cassette(cassette) do
        result = Interface::IRely::EntityUpdate.call(
          base_url: Figaro.env.IRELY_BASE_URL,
          credentials: credentials,
          request: request
        )
      end
      result
    end
    let(:insert_data) do
      result = nil
      VCR.use_cassette('entity import') do
        result = Interface::IRely::EntityInsert.call(
          base_url: Figaro.env.IRELY_BASE_URL,
          credentials: credentials,
          request: insert_request
        )
      end
      result.payload[:data][0]
    end
    let(:local_id) { Time.now.to_i }
    # let(:local_id) { 10002 }
    let(:insert_request) do
      {
        id: local_id + 1,
        name: Faker::Company.name,
        entity_type: %w{company person}.sample,
        customer: {
          id: local_id,
          credit_limit: 0
        },
        contacts: [
          {
            id: local_id + 2,
            name: Faker::Name.name,
            phone_number: Faker::PhoneNumber.phone_number,
            fax_number: Faker::PhoneNumber.phone_number,
            mobile_number: Faker::PhoneNumber.phone_number,
            email_address: Faker::Internet.email
          }
        ],
        locations: [
          {
            id: local_id + 2,
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

    context 'when the credentials are invalid' do
      pending 'the api call should fail and return a failure'
    end

    context 'when updating an existing customer' do
      let(:cassette) { 'entity sync' }
      let(:entity_name) { Faker::Company.name }
      let(:request) do
        {
          # id: local_id,
          name: entity_name,
          entity_type: %w{company person}.sample,
          interface_id: insert_data[:interface_id].to_i,
          customer: {
            # id: local_id,
            credit_limit: 0
          },
          contacts: [
            {
              # id: local_id + 1,
              name: Faker::Name.name,
              phone_number: Faker::PhoneNumber.phone_number,
              fax_number: Faker::PhoneNumber.phone_number,
              mobile_number: Faker::PhoneNumber.phone_number,
              email_address: Faker::Internet.email,
              interface_id: insert_data[:contacts][0][:interface_id].to_i
            }
          ],
          locations: [
            {
              # id: local_id + 2,
              name: entity_name,
              street_address: Faker::Address.street_address,
              city: Faker::Address.city,
              region: Faker::Address.state,
              region_code: Faker::Address.zip_code,
              country: 'United States',
              interface_id: insert_data[:locations][0][:interface_id].to_i
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

    context 'when updating an existing customer with a new contact' do
      pending 'adds the new contact'
    end
  end
end

FactoryGirl.define do
  factory :contact_request, class: Hash do
  end
end
