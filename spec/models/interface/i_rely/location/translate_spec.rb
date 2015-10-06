require 'rails_helper'

RSpec.describe Interface::IRely::Location::Translate,
               type: :model do

  let(:payload) { build(:location_payload) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Location::Translate.new(payload) }

    describe '.output' do
      subject { call.output }

      its([:name]) { is_expected.to eq payload.location_name }
      its([:phone]) { is_expected.to eq payload.phone_number }
      its([:fax]) { is_expected.to eq payload.fax_number }
      its([:address]) { is_expected.to eq payload.street_address }
      its([:city]) { is_expected.to eq payload.city }
      its([:state]) { is_expected.to eq payload.region }
      its([:zipcode]) { is_expected.to eq payload.region_code }
      its([:country]) { is_expected.to eq payload.country }

      context 'when the payload has no interface_id' do
        let(:payload) { build(:location_payload, interface_id: nil) }

        its([:id]) { is_expected.to eq payload.id }
        its([:interface_id]) { is_expected.to be nil }
        its([:rowState]) { is_expected.to eq 'Added' }
      end

      context 'when the payload has an interface_id' do
        let(:payload) { build(:location_payload, interface_id: 1) }

        its([:id]) { is_expected.to be nil }
        its([:i21_id]) { is_expected.to eq payload.interface_id }
        its([:rowState]) { is_expected.to eq 'Modified' }
      end
    end
  end

  describe '#translate' do
    before do
      Interface::IRely::Location::Translate
    end
    let(:translate) do
      allow(Interface::IRely::Location::Translate)
        .to receive(:new)
        .and_return(spy)

      Interface::IRely::Location::Translate.translate(payload)
    end
    subject { translate }

    context 'when there is one item to translate' do
      let(:payload) { build(:location_payload) }

      its(:size) { is_expected.to eq 1 }
      it 'should build one translation' do
        subject

        expect(Interface::IRely::Location::Translate)
          .to have_received(:new).once
      end
    end

    context 'when there is more than one item to translate' do
      let(:payload) { build_list(:location_payload, 2) }

      its(:size) { is_expected.to eq payload.size }
      it 'should build the same number of translations as items' do
        subject

        expect(Interface::IRely::Location::Translate)
          .to have_received(:new).exactly(payload.size).times
      end
    end
  end
end
