require 'rails_helper'

RSpec.describe Interface::Entity::Request, type: :model do
  describe '#call' do
    let(:context) { Interface::ObjectContext.new(entity, organization) }
    let(:entity) { build_stubbed(:entity) }
    let(:interface) { spy }
    let(:organization) { double(:organization) }
    let(:model) { Interface::Entity::Request.new(context, interface) }
    subject { model.call }

    it 'should call the interface' do
      subject

      expect(interface).to have_received(:call)
    end

    # TODO: Test that object maps have been created.
    #       These should be created from a "payload"
  end
end
