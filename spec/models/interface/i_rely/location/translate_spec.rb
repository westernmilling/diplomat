require 'rails_helper'

RSpec.describe Interface::IRely::Location::Translate,
               type: :model do
  let(:context) do
    Interface::ObjectContext.new(location, organization)
  end
  let(:location) do
    stub_data = attributes_for(:location,
                               id: 1,
                               location_name: Faker::Company.name)
    stub_data[:interface_object_maps] = []
    double(Location, stub_data)
  end
  let(:organization) { build(:organization) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Location::Translate.new(context) }

    describe '.output' do
      subject { call.output }

      its([:name]) { is_expected.to eq location.location_name }
      its([:phone]) { is_expected.to eq location.phone_number }
      its([:fax]) { is_expected.to eq location.fax_number }
      its([:address]) { is_expected.to eq location.street_address }
      its([:city]) { is_expected.to eq location.city }
      its([:state]) { is_expected.to eq location.region }
      its([:zipcode]) { is_expected.to eq location.region_code }
      its([:country]) { is_expected.to eq location.country }

      context 'when the context has no interface_id' do

        its([:id]) { is_expected.to eq location.id }
        its([:interface_id]) { is_expected.to be nil }
        its([:rowState]) { is_expected.to eq 'Added' }
      end

      context 'when the context has an interface_id' do
        before do
          allow(location)
            .to receive(:interface_object_maps)
            .and_return(maps)
        end
        let(:maps) do
          [double(:map,
                  organization: organization,
                  id: location.id,
                  interface_id: 1 )]
        end

        its([:id]) { is_expected.to be location.id }
        its([:i21_id]) { is_expected.to eq maps[0].interface_id }
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
