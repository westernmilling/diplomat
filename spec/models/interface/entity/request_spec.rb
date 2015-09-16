require 'rails_helper'

RSpec.describe Interface::Entity::Request, type: :model do
  describe '#call' do
    before do
    end
    let(:context) { Interface::ObjectContext.new(entity, organization) }
    let(:entity) { double(:entity) }
    let(:organization) { double(:organization) }
    let(:model) { Interface::Entity::Request.new(context) }
    subject { model.call }

    pending 'need to write test to make sure interface is called'

    # TODO: Need to test that the entity ahesive is updated somewhere.
    #       Would it be best to do this in the wrapper class?
  end
end
