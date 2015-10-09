require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Insert, type: :model, vcr: true do
  describe '.call' do
    before do
      # Mock the ApiClients::ImportEntity and result
    end
    let(:instance) { described_class.new(context) }
    let(:context) { ObjectContext.new(entity, organization) }
    let(:result) { instance.call }

    context 'when the api call is successful' do
      # Updates the object in context, success log and maps
    end

    context 'when the api call is not successful' do
      # Updates the object in context, failure log
    end
  end
end
