require 'rails_helper'

RSpec.describe Interface::IRely::Contact::Translate,
               type: :model do

  let(:context) do
    Interface::ObjectContext.new(contact, organization)
  end
  let(:contact) do
    temp = build_stubbed(:contact)
    allow(temp).to receive(:interface_object_maps).and_return([])
    temp
  end
  let(:organization) { build(:organization) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Contact::Translate.new(context) }

    describe '.output' do
      subject { call.output }

      its([:name]) { is_expected.to eq contact.full_name }
      its([:phone]) { is_expected.to eq contact.phone_number }
      its([:fax]) { is_expected.to eq contact.fax_number }
      its([:email]) { is_expected.to eq contact.email_address }

      context 'when the context has no interface_id' do
        its([:id]) { is_expected.to eq contact.id }
        its([:interface_id]) { is_expected.to be nil }
        its([:rowState]) { is_expected.to eq 'Added' }
      end

      context 'when the context has an interface_id' do
        before do
          allow(contact)
            .to receive(:interface_object_maps)
            .and_return(maps)
        end
        let(:maps) do
          [double(:map,
                  organization: organization,
                  id: contact.id,
                  interface_id: 1 )]
        end

        its([:id]) { is_expected.to eq contact.id }
        its([:i21_id]) { is_expected.to eq maps[0].interface_id }
        its([:rowState]) { is_expected.to eq 'Modified' }
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
