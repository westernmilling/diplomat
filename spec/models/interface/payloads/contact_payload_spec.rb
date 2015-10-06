require 'rails_helper'

RSpec.describe Interface::Payloads::ContactPayload, type: :model do
  let(:context) { Interface::ObjectContext.new(contact, organization) }
  let(:contact) { build_stubbed(:contact) }
  let(:organization) { build_stubbed(:organization) }

  describe '.build_one' do
    subject { Interface::Payloads::ContactPayload.build_one(context) }

    its(:id) { is_expected.to eq context.object.id }
    its(:full_name) { is_expected.to eq context.object.full_name }
    its(:email_address) { is_expected.to eq context.object.email_address }
    its(:fax_number) { is_expected.to eq context.object.fax_number }
    its(:mobile_number) { is_expected.to eq context.object.mobile_number }
    its(:phone_number) { is_expected.to eq context.object.phone_number }
    its(:uuid) { is_expected.to eq context.object.uuid }

    context 'when the contact has no adhesive for the organization' do
      its(:interface_id) { is_expected.to be_nil }
    end

    context 'when the contact has adhesive for the organization' do
      before do
        allow(contact)
          .to receive(:interface_object_maps)
          .and_return(
            [
              Interface::ObjectMap.new(organization: organization,
                                       interfaceable: contact,
                                       interface_id: Faker::Number.number(4),
                                       version: 1)
            ]
          )
      end

      its(:interface_id) { is_expected.to be_present }
    end
  end

  describe '.build' do
    subject { Interface::Payloads::ContactPayload.build(context) }

    context 'when there is one contact' do
      its(:size) { is_expected.to eq 1 }
    end

    context 'when there is more than one contact' do
      let(:context) do
        [
          Interface::ObjectContext.new(build_stubbed(:contact), organization),
          Interface::ObjectContext.new(build_stubbed(:contact), organization)
        ]
      end

      its(:size) { is_expected.to eq context.length }
    end
  end
end
