require 'rails_helper'


module Interface
  class UpsertEntity
    def initialize(entity, organization)
      @context = Interface::ObjectContext.new(entity, organization)
      # @coherance = Interface::Coherance(entity, organization)
    end

    def call
      Interface::InterfaceFactory.build(@context).call

      # TODO: Do we persist the entity and children here?
    end
  end
end


RSpec.describe Interface::UpsertEntity, type: :model do
  describe '#call' do
    before do
      allow(Interface::InterfaceFactory)
        .to receive(:build)
        .and_return(action_model)
    end
    let(:action_model) { spy(:action) }
    let(:entity) { double(:entity) }
    let(:organization) { double(:organization) }
    let(:model) { Interface::UpsertEntity.new(entity, organization) }
    subject { model.call }

    it do
      subject

      expect(action_model).to have_received(:call)
    end
  end
end
