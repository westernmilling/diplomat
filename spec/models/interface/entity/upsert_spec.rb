require 'rails_helper'

RSpec.describe Interface::Entity::Upsert, type: :model do
  describe '#call' do
    let(:request) { spy }
    let(:entity) { double(:entity, save!: true) }
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
    end

    describe 'entity' do
      it do
        subject

        expect(entity).to have_received(:save!)
      end
    end
  end
end
