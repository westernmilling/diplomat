class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  after_action :verify_authorized, if: :needs_authorization?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Exception, with: :growl_error
  # Handle Pundit::NotAuthorizedError differently then other exceptions
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def growl_error(exception)
    raise exception if Rails.env.to_sym == :test

    # TODO: Log to Airbrake

    @exception = exception

    respond_to do |format|
      format.html { render template: 'error', status: 500 }
      format.js do
        render_growl(exception.message,
                     'Unexpected error occured',
                     'danger', true)
      end
    end
  end

  def handle_service_result(result, on_success, on_failure)
    if result.success?
      flash[:notice] = result.message
      on_success.call
    else
      flash[:alert] = result.message
      on_failure.call
    end
  end

  def needs_authorization?
    !devise_controller? && user_signed_in?
  end

  def render_growl(message,
                   header = nil,
                   state = 'success',
                   sticky = false)
    render partial: '/growl',
           locals: {
             message: message, header: header, state: state, sticky: sticky
           }
  end

  def user_not_authorized
    redirect_to(
      request.referrer || root_path,
      alert: t('access_denied'))
  end
end
