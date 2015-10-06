require 'rails_helper'

RSpec.describe Interface::IRely::Customer::Translate,
               type: :model do

  let(:payload) { build(:customer_payload) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Customer::Translate.new(payload) }

    describe '.output' do
      subject { call.output }

      its([:creditLimit]) { is_expected.to eq 0 }
      its([:type]) { is_expected.to eq payload.customer_type.capitalize }
    end
  end

  describe '#translate' do
    before do
      Interface::IRely::Customer::Translate
    end
    let(:customer_double) do
      temp = double
      allow(temp).to receive(:output).and_return({})
      allow(temp).to receive(:call).and_return(temp)
      temp
    end
    let(:translate) do
      allow(Interface::IRely::Customer::Translate)
        .to receive(:new)
        .and_return(customer_double)

      Interface::IRely::Customer::Translate.translate(payload)
    end
    subject { translate }

    it { is_expected.to eq({}) }
  end
end
