require 'rails_helper'

RSpec.describe Interface::IRely::EntityInsert, type: :interactor, vcr: true do
  # TODO: Filter the following and populate from Figaro
  # API URL, API KEY, API SECRET

  describe '.call' do
    let(:entity) { create(:entity) }
    let!(:customer) do
      create(:customer,
            entity: entity,
            bill_to_location: entity.locations[0],
            ship_to_location: entity.locations[0])
    end
    subject do
      result = nil
      VCR.use_cassette('entity_customer') do
        result = Interface::IRely::EntityInsert.call(entity: entity)
      end
      result
    end

    # TODO: Use contexts for customer, vendor, combined updates

    it { is_expected.to be_success }
    its(:status) {}
    its(:payload) {}
    its(:identifier) {}
  end
end
