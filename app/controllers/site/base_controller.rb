# Site module
module Site
  # Base site controller
  class BaseController < ApplicationController
    layout 'site'

    skip_before_filter :authenticate_user!
  end
end
