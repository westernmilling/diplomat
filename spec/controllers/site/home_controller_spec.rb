require 'rails_helper'

RSpec.describe Site::HomeController, type: :controller do
  describe 'GET index' do
    before { get :index }

    it_behaves_like 'a successful request'
    it_behaves_like 'an index request'
  end
end
