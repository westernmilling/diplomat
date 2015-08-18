require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    sign_in(build_stubbed(:user))

    allow(User).to receive(:find) { user }
  end
  let(:user) { build_stubbed(:user) }

  describe 'GET edit' do
    before { get :edit, id: user.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'an edit request'
  end

  describe 'GET index' do
    before do
      allow(controller).to receive(:users) { users }
      get :index
    end
    let(:users) { build_stubbed_list(:user, 2).map(&:decorate) }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
  end

  describe 'GET show' do
    before { get :show, id: user.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'a show request'
  end

  describe 'PATCH update' do
    before do
      allow(UpdateUser).to receive(:call).and_return(context)

      patch :update,
            id: user.id,
            entry: {
              name: Faker::Name.name,
              is_active: [0, 1].sample
            }
    end
    let(:context) do
      double(:context, user: user, message: '', success?: success?)
    end
    let(:success?) { fail 'success? not set' }

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
      allow(InviteUser).to receive(:call).and_return(context)

      post :create,
           entry: {
             email: Faker::Internet.email,
             name: Faker::Name.name,
             is_active: [0, 1].sample
           }
    end
    let(:context) do
      double(:context, user: user, message: '', success?: success?)
    end
    let(:success?) { fail 'success? not set' }

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
