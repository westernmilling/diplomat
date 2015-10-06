require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Translate,
               type: :model do

  let(:payload) do
    build(:entity_payload, :with_contact, :with_customer, :with_location)
  end

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Entity::Translate.new(payload) }

    describe '.output' do
      subject { call.output }

      its([:name]) { is_expected.to eq payload.name }
      its([:entityNo]) { is_expected.to eq payload.reference }
      its([:contacts]) { is_expected.to_not be_empty }
      its([:customer]) { is_expected.to_not be_empty }
      its([:locations]) { is_expected.to_not be_empty }

      context 'when the payload has no interface_id' do
        let(:payload) { build(:entity_payload, interface_id: nil) }

        its([:id]) { is_expected.to eq payload.id }
        its([:interface_id]) { is_expected.to be nil }
        # its([:rowState]) { is_expected.to eq 'Added' }
      end

      context 'when the payload has an interface_id' do
        let(:payload) { build(:entity_payload, interface_id: 1) }

        its([:id]) { is_expected.to be nil }
        its([:i21_id]) { is_expected.to eq payload.interface_id }
        # its([:rowState]) { is_expected.to eq 'Modified' }
      end
    end
  end

  describe '#translate' do
    let(:translate) do
      allow(Interface::IRely::Entity::Translate)
        .to receive(:new)
        .and_return(spy)

      Interface::IRely::Entity::Translate.translate(payload)
    end
    subject { translate }

    context 'when there is one item to translate' do
      let(:payload) { build(:entity_payload) }

      its(:size) { is_expected.to eq 1 }
      it 'should build one translation' do
        subject

        expect(Interface::IRely::Entity::Translate)
          .to have_received(:new).once
      end
    end

    context 'when there is more than one item to translate' do
      let(:payload) { build_list(:entity_payload, 2) }

      its(:size) { is_expected.to eq payload.size }
      it 'should build the same number of translations as items' do
        subject

        expect(Interface::IRely::Entity::Translate)
          .to have_received(:new).exactly(payload.size).times
      end
    end
  end
end
