require 'rails_helper'

RSpec.describe Interface::Payloads::EntityPayload, type: :model do
  let(:context) { Interface::ObjectContext.new(object, organization) }
  let(:object) do
    entity = build_stubbed(:entity)
    allow(entity)
      .to receive(:contacts)
      .and_return(build_stubbed_list(:contact, 2, entity: entity))
    allow(entity)
      .to receive(:locations)
      .and_return(build_stubbed_list(:location, 2, entity: entity))
    allow(entity)
      .to receive(:customer)
      .and_return(build_stubbed(:customer, entity: entity))
    entity
  end

  let(:organization) { build_stubbed(:organization) }

  describe '.build_one' do
    subject { described_class.build_one(context) }

    its(:id) { is_expected.to eq context.object.id }
    its(:name) { is_expected.to eq context.object.name }
    its(:reference) { is_expected.to eq context.object.reference }
    its(:uuid) { is_expected.to eq context.object.uuid }
    its(:contacts) { is_expected.to_not be_empty }
    its(:locations) { is_expected.to_not be_empty }

    context 'when the customer trait is present' do
      its(:customer) { is_expected.to_not be_empty }
    end

    context 'when the object has no adhesive for the organization' do
      its(:interface_id) { is_expected.to be_nil }
    end

    context 'when the object has adhesive for the organization' do
      before do
        allow(object)
          .to receive(:interface_adhesives)
          .and_return(
            [
              Interface::Adhesive.new(organization: organization,
                                      interfaceable: object,
                                      interface_id: Faker::Number.number(4),
                                      version: 1)
            ]
          )
      end

      its(:interface_id) { is_expected.to be_present }
    end
  end

  describe '.build' do
    subject { described_class.build(context) }

    context 'when there is one object' do
      its(:size) { is_expected.to eq 1 }
    end

    context 'when there is more than one object' do
      let(:context) do
        [
          Interface::ObjectContext.new(build_stubbed(:entity), organization),
          Interface::ObjectContext.new(build_stubbed(:entity), organization)
        ]
      end

      its(:size) { is_expected.to eq context.length }
    end
  end
end
