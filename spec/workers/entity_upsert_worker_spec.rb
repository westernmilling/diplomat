require 'rails_helper'

RSpec.describe EntityUpsertWorker, type: :worker do
  before do
    allow(Interface::ProcessEntityOrganizationsUpsert)
      .to receive(:call)
      .and_return(double(:context, message: Faker::Lorem.sentence))
  end

  describe '.perform_async' do
    it 'increases the job size by 1' do
      expect do
        EntityUpsertWorker.perform_async(1, 1)
      end.to change(EntityUpsertWorker.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    subject { EntityUpsertWorker.new.perform(1, 1) }

    it 'calls the ProcessEntityOrganizationsUpsert interactor' do
      subject

      expect(Interface::ProcessEntityOrganizationsUpsert)
        .to have_received(:call)
    end
  end
end
