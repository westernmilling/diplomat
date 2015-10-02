require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Insert, type: :model, vcr: true do
# RSpec.describe Interface::IRely::Entity::Insert, type: :model, vcr: false do
  describe '.call' do
    let(:credentials) do
      return Interface::IRely::Credentials
             .new(Figaro.env.IRELY_API_KEY,
                  Figaro.env.IRELY_API_SECRET,
                  Figaro.env.IRELY_COMPANY)
      # "#{Figaro.env.IRELY_API_KEY}:#{Figaro.env.IRELY_API_SECRET}" + \
      #   "@#{Figaro.env.IRELY_COMPANY}"
    end
    let(:api) do
      Interface::IRely::Entity::Insert.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        data
      )
    end
    let(:data) do
      nil
    end
    let(:result) do
      # return api.call
      # result = nil
      # r = nil
      # # VCR.use_cassette(cassette) do
      #   # result = api.call
        r = api.call
        puts r
      #   # return r
      #   # return api.call
      # # end
      # # result
      r
    end
    # subject { call }

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
        # entity_payload = build(:entity_payload, id: Time.now.utc.to_i)
        # entity_payload.contacts << build(:contact_payload, id: Time.now.utc.to_i)
        # entity_payload.customer << build(:customer_payload, id: Time.now.utc.to_i)
        # entity_payload.locations << build(:location_payload, id: Time.now.utc.to_i)
        # entity_payload
        build(:entity_payload, id: Time.now.utc.to_i) do |payload|
          payload.contacts << build(:contact_payload, id: Time.now.utc.to_i)
          payload.customer = build(:customer_payload,
                                   id: Time.now.utc.to_i,
                                   customer_type: payload.entity_type)
          payload.locations << build(:location_payload,
                                     id: Time.now.utc.to_i,
                                     location_name: nil)
        end
      end

      subject { result }

      its([:success]) { is_expected.to be true }
    end

    context 'when inserting an invalid entity' do
      let(:data) do
        contact_payload = nil
        customer_payload = nil
        location_payload = nil
        entity_payload = build(:entity_payload, id: Time.now.utc.to_i)
      end

      subject { result }

      its([:success]) { is_expected.to be false }
    end
  end
end
