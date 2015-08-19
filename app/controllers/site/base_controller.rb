# Site module
module Site
  # Base site controller
  class BaseController < ApplicationController
    layout 'site'

    skip_before_filter :authenticate_user!
    skip_after_action :verify_authorized
  end
end
