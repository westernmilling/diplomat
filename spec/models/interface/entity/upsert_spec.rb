require 'rails_helper'

RSpec.describe Interface::Entity::Upsert, type: :model do
  describe '#call' do
    let(:request) { spy }
    let(:entity) { double(:entity) }
    let(:organization) { double(:organization) }
    let(:model) do
      Interface::Entity::Upsert.new(entity, organization, request)
    end
    subject { model.call }

    describe 'request' do
      it do
        subject

        expect(request).to have_received(:call)
      end

      pending 'test that the entity is persisted'
    end
  end
end
