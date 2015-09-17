require 'rails_helper'

RSpec.describe Interface::Payloads::CustomerPayload, type: :model do
  let(:context) { Interface::ObjectContext.new(object, organization) }
  let(:object) { build_stubbed(:customer) }
  let(:organization) { build_stubbed(:organization) }

  describe '.build_one' do
    subject { Interface::Payloads::CustomerPayload.build_one(context) }

    its(:id) { is_expected.to eq context.object.id }
    its(:uuid) { is_expected.to eq context.object.uuid }

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
    subject { Interface::Payloads::CustomerPayload.build(context) }

    context 'when there is one object' do
      its(:size) { is_expected.to eq 1 }
    end

    context 'when there is more than one object' do
      let(:context) do
        [
          Interface::ObjectContext.new(build_stubbed(:customer), organization),
          Interface::ObjectContext.new(build_stubbed(:customer), organization)
        ]
      end

      its(:size) { is_expected.to eq context.length }
    end
  end
end
