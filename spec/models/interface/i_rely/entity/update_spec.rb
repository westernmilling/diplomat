require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Update, type: :model, vcr: true do
  describe '.call' do
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
      Interface::IRely::Entity::Insert.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        new_data
      ).call

      # puts new_data.to_yaml

      # return {}
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
        temp_data.contacts[0].full_name = Faker::Name.name
        temp_data
      end

      subject { result }

      its([:success]) { is_expected.to be true }
    end

    context 'when a new contact is added' do
      let(:data) do
        temp_data = new_data.dup
        temp_data.contacts << build(:contact_payload, id: Time.now.utc.to_i)
        temp_data
      end

      subject { result }

      its([:success]) { is_expected.to be true }
      # it 'should populate the new contacts interface id' do
      #   # result
      #
      #   expect(data.contacts[1].interface_id).to_not be_nil
      # end
    end

    context 'when a new location is added' do
      let(:data) do
        temp_data = new_data.dup
        temp_data.locations << build(:location_payload,
                                     location_name: Faker::Company.name,
                                     id: Time.now.utc.to_i)
        temp_data
      end

      subject { result }

      its([:success]) { is_expected.to be true }
    end

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
