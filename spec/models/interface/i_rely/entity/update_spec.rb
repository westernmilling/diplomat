require 'rails_helper'

RSpec.describe Interface::IRely::Entity::Update, type: :model, vcr: true do
  describe '.call' do
    before do
      
    end
    let(:api) do
      Interface::IRely::Entity::Update.new(
        Figaro.env.IRELY_BASE_URL,
        credentials,
        data
      )
    end
    let(:data) { nil }
    let(:new_data) do

    end
    let(:result) do
    end
  end
end
