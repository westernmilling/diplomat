require 'rails_helper'

RSpec.describe Interface::IRely::Contact::Translate,
               type: :model do

  # let(:output) { Hash.new }
  let(:payload) { build(:contact_payload) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Contact::Translate.new(payload) }

    describe '.output' do
      subject { call.output }

      its([:name]) { is_expected.to eq payload.full_name }
      its([:phone]) { is_expected.to eq payload.phone_number }
      its([:fax]) { is_expected.to eq payload.fax_number }
      its([:email]) { is_expected.to eq payload.email_address }

      context 'when the payload has no interface_id' do
        let(:payload) { build(:contact_payload, interface_id: nil) }

        its([:id]) { is_expected.to eq payload.id }
        its([:interface_id]) { is_expected.to be nil }
        its([:rowState]) { is_expected.to eq 'Added' }
      end

      context 'when the payload has an interface_id' do
        let(:payload) { build(:contact_payload, interface_id: 1) }

        its([:id]) { is_expected.to be nil }
        its([:i21_id]) { is_expected.to eq payload.interface_id }
        its([:rowState]) { is_expected.to eq 'Updated' }
      end
    end
  end

  describe '#translate' do
    before do
      Interface::IRely::Contact::Translate
    end
    let(:translate) do
      allow(Interface::IRely::Contact::Translate)
        .to receive(:new)
        .and_return(spy)

      Interface::IRely::Contact::Translate.translate(payload)
    end
    subject { translate }

    context 'when there is one item to translate' do
      let(:payload) { build(:contact_payload) }

      its(:size) { is_expected.to eq 1 }
      it 'should build one translation' do
        subject

        expect(Interface::IRely::Contact::Translate)
          .to have_received(:new).once
      end
    end

    context 'when there is more than one item to translate' do
      let(:payload) { build_list(:contact_payload, 2) }

      its(:size) { is_expected.to eq payload.size }
      it 'should build the same number of translations as items' do
        subject

        expect(Interface::IRely::Contact::Translate)
          .to have_received(:new).exactly(payload.size).times
      end
    end
  end
end
