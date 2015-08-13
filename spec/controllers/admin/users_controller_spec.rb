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
    it { expect(assigns(:user)).to be_kind_of(User) }
  end

  describe 'GET index' do
    before do
      allow(controller).to receive(:users) { users }
      get :index
    end
    let(:users) { build_stubbed_list(:user, 2) }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
    it { expect(assigns(:users)).to be_kind_of(Array) }
    it { expect(assigns(:users)[0]).to be_kind_of(User) }
    it { expect(assigns(:users).size).to eq(users.size) }
  end

  describe 'GET show' do
    before { get :show, id: user.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'a show request'
    it { expect(assigns(:user)).to be_kind_of(User) }
  end

  describe 'PATCH update' do
    before do
      allow(user).to receive(:update_attributes) { update? }

      patch :update,
            id: user.id,
            user: { name: Faker::Name.name, is_active: [0, 1].sample }
    end
    let(:update?) { fail 'update? not set' }

    context 'when the update is successful' do
      let(:update?) { true }

      it_behaves_like 'a redirect'
      it { is_expected.to redirect_to(admin_user_path(user.id)) }
      it do
        is_expected
          .to set_flash[:notice].to(I18n.t('user.update.success'))
      end
    end

    context 'when the update is not successful' do
      let(:update?) { false }

      it_behaves_like 'a successful request'
      it_behaves_like 'an edit request'
      it { expect(assigns(:user)).to be_kind_of(User) }
      it do
        is_expected
          .to set_flash[:alert].to(I18n.t('user.update.failure'))
      end
    end
  end
end
