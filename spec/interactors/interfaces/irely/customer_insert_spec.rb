require 'vcr'
require 'rails_helper'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock #:faraday
end

RSpec.describe Interfaces::IRely::CustomerInsert, type: :interactor, :vcr => true do
  describe '.call' do
    let(:customer) { build(:customer) }
    subject do
      result = nil
      VCR.use_cassette('customer') do
        result = Interfaces::IRely::CustomerInsert.call(customer: customer)
      end
      result
    end

    it { is_expected.to be_success }
  end
end
