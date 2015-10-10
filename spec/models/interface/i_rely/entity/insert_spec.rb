require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Insert, type: :model, vcr: true do
  describe '.call' do
    before do
      client = double(:import_entity)
      # allow(Interface::IRely::ApiClients::ImportEntity)
      #   .to receive(:new).and_return(client)
      allow(client).to receive(:call).and_return(result)
    end
    let(:call) { instance.call }
    let(:instance) { described_class.new(context, client) }
    let(:context) { ObjectContext.new(entity, organization) }
    let(:result) do

    end

    context 'when the api call is successful' do
      # Updates the object in context, success log and maps
    end

    context 'when the api call is not successful' do
      # Updates the object in context, failure log
    end
  end
end
