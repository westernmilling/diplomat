require 'rails_helper'

RSpec.describe Interface::IRely::Customer::Translate,
               type: :model do
  let(:context) do
    Interface::ObjectContext.new(customer, organization)
  end
  let(:customer) do
    stub_data = attributes_for(:customer, id: 1)
    stub_data[:entity] = entity
    stub_data[:interface_object_maps] = []
    double(Customer, stub_data)
  end
  let(:entity) do
    stub_data = attributes_for(:entity, id: 1)
    stub_data[:interface_object_maps] = []
    double(Entity, stub_data)
  end
  let(:organization) { build(:organization) }

  describe '.call' do
    let(:call) { translate.call }
    let(:translate) { Interface::IRely::Customer::Translate.new(context) }

    describe '.output' do
      subject { call.output }

      its([:creditLimit]) { is_expected.to eq 0 }
      its([:type]) { is_expected.to eq entity.entity_type.capitalize }
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

      Interface::IRely::Customer::Translate.translate(context)
    end
    subject { translate }

    it { is_expected.to eq({}) }
  end
end
