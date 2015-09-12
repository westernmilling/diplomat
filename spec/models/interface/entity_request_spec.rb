require 'rails_helper'

RSpec.describe Interface::EntityRequest, type: :model do
  before do
    allow(interface).to receive(:call)
  end
  let(:entity) { build_stubbed(:entity) }
  let(:interface) { spy(:interface) }
  let(:organization) { build_stubbed(:organization) }
  let(:context) do
    # Interface::OrganizationEntityContext.new(entity, organization)
    Interface::StateContext.new(entity, organization)
  end

  describe '#call' do
    subject do
      Interface::EntityRequest
        .new(context, interface)
        .call
    end

    it 'should call the interface class' do
      subject

      expect(interface).to have_received(:call).once
    end

    # The information should be read back into the state data
  end
end
