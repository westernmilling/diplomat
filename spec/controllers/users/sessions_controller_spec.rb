require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET new' do
    before { get :new }

    it_behaves_like 'a successful request'
    it_behaves_like 'a new request'
  end

  describe 'POST create' do
    context 'when the authenticate succeeds' do
      before do
        user = build_stubbed(:user)
        allow(user).to receive(:save) { true }
        allow(request.env['warden'])
          .to receive(:authenticate!).and_return(user)

        post :create
      end

      it_behaves_like 'a redirect'
      it do
        is_expected
          .to set_flash[:notice].to(I18n.t('devise.sessions.signed_in'))
      end
    end

    context 'when the authenticate fails' do
      before do
        # None of these work :(
        # allow(request.env['warden'])
        #   .to receive(:authenticate)
        #   .and_throw(I18n.t('devise.failure.not_found_in_database'))
        # strategy = Devise::Strategies::DatabaseAuthenticatable
        #   .new(request.env, :user)
        # allow(strategy)
        #   .to receive(:authenticate!) { fail(:not_found_in_database) }
        # allow(Devise::Strategies::DatabaseAuthenticatable)
        #   .to receive(:new) { strategy }
        post :create
      end

      it_behaves_like 'a successful request'
      it_behaves_like 'a new request'
    end
  end
end
