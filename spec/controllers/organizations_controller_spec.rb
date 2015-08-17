require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  before do
    # allow(controller).to receive(:authorize) { authorize? }
    # allow(controller).to receive(:pundit_policy_authorized?) { authorize? }
    allow(Organization).to receive(:find) { organization }

    sign_in(build_stubbed(:user))
  end
  let(:authorize?) { true }

  describe 'GET index' do
    before do
      allow(controller).to receive(:organizations) { organizations }

      get :index
    end
    let(:organizations) { build_stubbed_list(:organization, 3) }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
    it { expect(controller.organizations).to be_kind_of Array }
    it { expect(controller.organizations.size).to eq organizations.size }
    it { expect(controller.organizations[0]).to be_kind_of Organization }

    # context 'when not authorized' do
    #   let(:authorize?) { raise_pundit_error OrganizationPolicy }
    #
    #   it { is_expected.to respond_with(302) }
    #   it { is_expected.to redirect_to(root_path) }
    #   it { is_expected.to set_flash[:alert] }
    # end
  end

  describe 'GET show' do
    before do
      allow(Organization).to receive(:find) { organization }

      get :show, id: organization.id
    end
    let!(:organization) { build_stubbed(:organization) }

    it_behaves_like 'a successful request'
    it_behaves_like 'a show request'
    it { expect(controller.organization).to be_kind_of(Organization) }

    # context 'when not authorized' do
    #   let(:authorize?) { raise_pundit_error OrganizationPolicy }
    #
    #   it { is_expected.to respond_with(302) }
    #   it { is_expected.to redirect_to(root_path) }
    #   it { is_expected.to set_flash[:alert] }
    # end
  end
end
