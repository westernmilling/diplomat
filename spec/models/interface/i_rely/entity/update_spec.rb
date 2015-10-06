require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Update, type: :model, vcr: true do
  describe '.call' do
    before do
      # TODO: Return the interface id's for the update
      Interface::IRely::Entity::Insert.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        new_data
      ).call

      puts new_data
    end
    let(:api) do
      Interface::IRely::Entity::Update.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        data
      )
    end
    let(:credentials) do
      Interface::IRely::Credentials
        .new(Figaro.env.IRELY_API_KEY,
             Figaro.env.IRELY_API_SECRET,
             Figaro.env.IRELY_COMPANY)
    end
    let(:data) { nil }
    let(:new_data) do
      build(:entity_payload,
            id: Time.now.utc.to_i,
            reference: Time.now.utc.to_i) do |payload|
        payload.contacts << build(:contact_payload, id: Time.now.utc.to_i)
        payload.customer = build(:customer_payload,
                                 id: Time.now.utc.to_i,
                                 customer_type: payload.entity_type)
        payload.locations << build(:location_payload,
                                   id: Time.now.utc.to_i,
                                   location_name: payload.name)
      end
    end
    let(:result) do
      return api.call
      # result = nil
      # r = api.call
      # puts r
      # r
    end

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

    context 'when updating a valid entity' do
      let(:data) do
        temp_data = new_data.dup
        temp_data.name = Faker::Company.name
        temp_data
      end

      subject { result }

      its([:success]) { is_expected.to be true }
    end

    # When adding a contact

    # When adding a location

    context 'when updating an invalid entity' do
      let(:data) do
        temp_data = new_data.dup
        temp_data.name = nil
        temp_data
      end

      subject { result }

      its([:success]) { is_expected.to be false }
    end
  end
end
