require 'rails_helper'

RSpec.describe Admin::IntegrationsController, type: :controller do
  before do
    allow(controller).to receive(:authorize) { authorize? }
    allow(controller).to receive(:pundit_policy_authorized?) { authorize? }
    allow(Integration).to receive(:find) { integration }

    sign_in(build_stubbed(:user))
  end
  let(:authorize?) { true }
  let!(:integration) { build_stubbed(:integration) }

  describe 'GET edit' do
    before { get :edit, id: integration.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'an edit request'
    it_behaves_like 'an unauthorized request', IntegrationPolicy
  end

  describe 'GET new' do
    before { get :new }

    it_behaves_like 'a successful request'
    it_behaves_like 'a new request'
    it_behaves_like 'an unauthorized request', IntegrationPolicy
  end

  describe 'PATCH update' do
    before do
      allow(integration).to receive(:update_attributes) { update? }

      patch :update, id: integration.id, integration: {}
    end
    let(:params) { fail 'params not set' }

    context 'when the integration details are valid' do
      let(:update?) { true }

      it_behaves_like 'a redirect'
      it { is_expected.to redirect_to(admin_integration_path(integration)) }
      it { is_expected.to set_flash[:notice] }
    end

    context 'when the integration details are not valid' do
      let(:update?) { false }

      it_behaves_like 'a successful request'
      it_behaves_like 'an edit request'
    end
    it_behaves_like 'an unauthorized request', IntegrationPolicy
  end

  describe 'POST create' do
    before do
      allow(Integration).to receive(:new) { integration }
      allow(integration).to receive(:save) { save? }

      post :create, integration: {}
    end

    context 'when the integration details are valid' do
      let(:save?) { true }

      it_behaves_like 'a redirect'
      it { is_expected.to redirect_to(admin_integration_path(integration)) }
      it { is_expected.to set_flash[:notice] }
    end

    context 'when the integration details are not valid' do
      let(:save?) { false }

      it_behaves_like 'a successful request'
      it_behaves_like 'a new request'
    end
    it_behaves_like 'an unauthorized request', IntegrationPolicy
  end
end
