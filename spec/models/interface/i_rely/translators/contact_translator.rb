require 'rails_helper'

RSpec.describe Interface::IRely::Translators::ContactTranslator,
               type: :model do

  describe '#translate_one' do
    let(:payload) { build(:contact_payload) }
    subject do
      Interface::IRely::Translators::ContactTranslator.translate_one(payload)
    end

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
