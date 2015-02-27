# Global application controller
class ApplicationController < ActionController::Base
  include Pundit

  after_action :verify_authorized, :if => :user_signed_in?
  before_action :authenticate_user!
  skip_after_action :verify_authorized, :if => :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  rescue_from Pundit::NotAuthorizedError, :with => :user_not_authorized

  # We could write some magic using method missing
  # but I'm not a big fan of magic.
  def redirect_with_notice(url, message)
    redirect_to(url, :notice => message)
  end

  def redirect_with_alert(url, message)
    redirect_to(url, :alert => message)
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    redirect_with_flash(
      request.referrer || root_path,
      :alert,
      t("#{policy_name}.#{exception.query}", :scope => :pundit))
  end
end
