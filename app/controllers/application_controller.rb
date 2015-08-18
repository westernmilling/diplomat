class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def handle_service_result(result, on_success, on_failure)
    if result.success?
      flash[:notice] = result.message
      on_success.call
    else
      flash[:alert] = result.message
      on_failure.call
    end
  end
end
