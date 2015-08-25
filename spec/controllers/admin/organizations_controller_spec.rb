require 'rails_helper'

RSpec.describe Admin::OrganizationsController, type: :controller do
  before do
    allow(controller).to receive(:authorize) { authorize? }
    allow(controller).to receive(:pundit_policy_authorized?) { authorize? }
    allow(Organization).to receive(:find) { organization }

    sign_in(build_stubbed(:user))
  end
  let(:authorize?) { true }

  describe 'GET edit' do
    before do
      allow(Organization).to receive(:find) { organization }

      get :edit, id: organization.id
    end
    let!(:organization) { build_stubbed(:organization) }

    it_behaves_like 'a successful request'
    it_behaves_like 'an edit request'
    it_behaves_like 'an unauthorized request', OrganizationPolicy
  end

  describe 'GET index' do
    before do
      allow(controller).to receive(:organizations) { organizations }

      get :index
    end
    let(:organizations) { build_stubbed_list(:organization, 3) }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
    it_behaves_like 'an unauthorized request', OrganizationPolicy
  end

  describe 'GET show' do
    before do
      allow(Organization).to receive(:find) { organization }

      get :show, id: organization.id
    end
    let!(:organization) { build_stubbed(:organization) }

    it_behaves_like 'a successful request'
    it_behaves_like 'a show request'
    it_behaves_like 'an unauthorized request', OrganizationPolicy
  end

  describe 'PATCH update' do
    before do
      allow(Organization).to receive(:find) { organization }
      allow(organization).to receive(:update_attributes) { update? }

      patch :update, id: organization.id, organization: {}
    end
    let!(:organization) { build_stubbed(:organization) }
    let(:update?) { true }

    it_behaves_like 'a redirect'
    it { is_expected.to redirect_to(admin_organization_path(organization)) }
    it { is_expected.to set_flash[:notice] }
    it_behaves_like 'an unauthorized request', OrganizationPolicy
  end
end
