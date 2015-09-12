require 'rails_helper'

RSpec.describe Interface::ContactPayload, type: :model do
  let(:context) { Interface::StateContext.new(contact, organization) }
  let(:contact) { build_stubbed(:contact) }
  let(:organization) { build_stubbed(:organization) }

  describe '.build_one' do
    subject { Interface::ContactPayload.build_one(context) }

    its(:id) { is_expected.to eq context.object.id }
    its(:full_name) { is_expected.to eq context.object.full_name }

    context 'when the contact has no state for the organization' do
      its(:interface_id) { is_expected.to be_nil }
    end

    context 'when the contact has no state for the organization' do
      before do
        allow(contact)
          .to receive(:interface_states)
          .and_return(
            [
              Interface::State.new(organization: organization,
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
    subject { Interface::ContactPayload.build(context) }

    context 'when there is one contact' do
      its(:size) { is_expected.to eq 1 }
    end

    context 'when there is more than one contact' do
      let(:context) do
        [
          Interface::StateContext.new(build_stubbed(:contact), organization),
          Interface::StateContext.new(build_stubbed(:contact), organization)
        ]
      end

      its(:size) { is_expected.to eq context.length }
    end
  end
end
