require 'rails_helper'

RSpec.describe CustomerUpsertWorker, type: :worker do
  before do
    allow(Interface::ProcessCustomerOrganizationsUpsert)
      .to receive(:call)
      .and_return(double(:context, message: Faker::Lorem.sentence))
  end

  describe '.perform_async' do
    it 'increases the job size by 1' do
      expect do
        CustomerUpsertWorker.perform_async(1, 1)
      end.to change(CustomerUpsertWorker.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    subject { CustomerUpsertWorker.new.perform(1, 1) }

    it 'calls the ProcessCustomerOrganizationsUpsert interactor' do
      subject

      expect(Interface::ProcessCustomerOrganizationsUpsert)
        .to have_received(:call)
    end
  end
end
