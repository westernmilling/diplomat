require 'rails_helper'

RSpec.describe EntitiesController, type: :controller do
  before do
    allow(controller).to receive(:authorize) { authorize? }
    allow(controller).to receive(:pundit_policy_authorized?) { authorize? }
    allow(Entity).to receive(:find) { entity }

    sign_in(build_stubbed(:user))
  end
  let(:authorize?) { true }
  let(:entity) { build_stubbed(:entity) }

  describe '#index' do
    before { get :index }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
    it_behaves_like 'an unauthorized request', EntityPolicy
  end

  describe '#show' do
    before { get :show, id: entity.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'a show request'
    it_behaves_like 'an unauthorized request', EntityPolicy
  end
end
