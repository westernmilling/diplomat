require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Update, type: :model, vcr: true do
  describe '#call' do
    let(:api_result) do
      Interface::IRely::ApiClients::Result.new(api_response)
    end
    let(:call) { instance.call }
    let(:client) do
      stubbed = double(:sync_entity)
      allow(stubbed).to receive(:call).and_return(api_result)
      stubbed
    end
    let(:instance) { described_class.new(context, client) }
    let(:context) { Interface::ObjectContext.new(entity, organization, graph) }
    let(:entity) do
      stubbed = build_stubbed(:entity, _v: 2)
      allow(stubbed).to receive(:contacts).and_return([contact])
      allow(stubbed).to receive(:locations).and_return([location])
      allow(stubbed).to receive(:customer).and_return(customer)
      stubbed
    end
    let(:contact) do
      build_stubbed(:contact, _v: 2)
    end
    let(:customer) do
      build_stubbed(:customer, _v: 2)
    end
    let(:location) do
      build_stubbed(:location, _v: 2, location_name: Faker::Company.name)
    end
    let(:organization) { build_stubbed(:organization) }
    let(:graph) { { contacts: nil, locations: nil, customer: nil } }

    context 'when the api call is successful' do
      before { call }

      let(:api_response) do
        {
          data: [
            {
              name: entity.name,
              contacts: [
                {
                  name: contact.full_name,
                  id: contact.id,
                  i21_id: rand(1001..2000)
                }
              ],
              locations: [
                {
                  name: location.location_name,
                  id: location.id,
                  i21_id: rand(2001..3000)
                }
              ],
              customer: {
                i21_id: rand(3001..4000)
              },
              id: entity.id,
              i21_id: rand(1..1000)
            }
          ],
          success: true
        }
      end

      describe 'context#root_instance#interface_object_maps[0]' do
        subject { context.root_instance.interface_object_maps[0] }

        its(:interface_id) do
          is_expected.to eq api_result.hash_response[:data][0][:i21_id].to_s
        end
      end

      describe 'context#root_instance#interface_logs[0]' do
        subject { context.root_instance.interface_logs[0] }

        its(:organization) { is_expected.to eq organization }
        its(:interfaceable) { is_expected.to eq entity }
        its(:interface_response) do
          is_expected.to eq api_result.raw_response.to_s
        end
        its(:status) { is_expected.to eq :success }
        its(:action) { is_expected.to eq :update }
        its(:version) { is_expected.to eq entity._v }
      end
    end

    context 'when the api call is not successful' do
      before { call }

      let(:api_response) do
        {
          data: [],
          success: false,
          message: 'An error has occurred'
        }
      end

      describe 'context#root_instance#interface_object_maps[0]' do
        subject { context.root_instance.interface_object_maps[0] }

        it 'should be nil' do
          expect(subject).to be_nil
        end
      end
      describe 'context#root_instance#interface_logs[0]' do
        subject { context.root_instance.interface_logs[0] }

        its(:organization) { is_expected.to eq organization }
        its(:interfaceable) { is_expected.to eq entity }
        its(:interface_response) do
          is_expected.to eq api_result.raw_response.to_s
        end
        its(:message) { is_expected.to eq api_result.message }
        its(:status) { is_expected.to eq :failure }
        its(:action) { is_expected.to eq :update }
        its(:version) { is_expected.to eq entity._v }
      end
    end
  end
end
