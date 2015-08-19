require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    allow(controller).to receive(:authorize) { authorize? }
    allow(controller).to receive(:pundit_policy_authorized?) { authorize? }
    allow(User).to receive(:find) { user }

    sign_in(user)
  end
  let(:authorize?) { true }
  let(:user) { build_stubbed(:user) }

  describe 'GET edit' do
    before { get :edit, id: user.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'an edit request'
    it_behaves_like 'an unauthorized request', UserPolicy
  end

  describe 'GET index' do
    before do
      allow(controller).to receive(:users) { users }
      get :index
    end
    let(:users) { build_stubbed_list(:user, 2).map(&:decorate) }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
    it_behaves_like 'an unauthorized request', UserPolicy
  end

  describe 'GET show' do
    before { get :show, id: user.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'a show request'
    it_behaves_like 'an unauthorized request', UserPolicy
  end

  describe 'PATCH update' do
    before do
      allow(UpdateUser).to receive(:call) { context }

      patch :update,
            id: user.id,
            entry: {
              name: Faker::Name.name,
              is_active: [0, 1].sample
            }
    end
    let(:context) { double(user: user, message: '', success?: success?) }
    let(:success?) { fail 'success? not set' }

    it_behaves_like 'an unauthorized request', UserPolicy

    context 'when the call is successful' do
      let(:success?) { true }

      it_behaves_like 'a redirect'
      it { is_expected.to redirect_to(admin_user_path(user)) }
      it { is_expected.to set_flash[:notice] }
    end
    context 'when the call is not successful' do
      let(:success?) { false }

      it_behaves_like 'a successful request'
      it_behaves_like 'an edit request'
      it { is_expected.to set_flash[:alert] }
    end
  end

  describe 'POST create' do
    before do
      allow(InviteUser).to receive(:call) { context }

      post :create,
           entry: {
             email: Faker::Internet.email,
             name: Faker::Name.name,
             is_active: [0, 1].sample
           }
    end
    let(:context) { double(user: user, message: '', success?: success?) }
    let(:success?) { fail 'success? not set' }

    it_behaves_like 'an unauthorized request', UserPolicy

    context 'when the call is successful' do
      let(:success?) { true }

      it_behaves_like 'a redirect'
      it { is_expected.to redirect_to(admin_user_path(user)) }
      it { is_expected.to set_flash[:notice] }
    end
    context 'when the call is not successful' do
      let(:success?) { false }

      it_behaves_like 'a successful request'
      it_behaves_like 'a new request'
      it { is_expected.to set_flash[:alert] }
    end
  end
end
