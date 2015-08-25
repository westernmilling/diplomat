class Admin::IntegrationsController < ApplicationController
  before_action -> { authorize :integration }, except: [:show]
  before_action -> { authorize integration }, only: :show

  helper_method :integration, :integrations, :search

  def create
    render :new and return unless integration.save

    redirect_to admin_integration_path(integration),
                notice: t('integrations.create.success')
  end

  def update
    render :edit and return unless \
      integration.update_attributes(integration_params)

    redirect_to admin_integration_path(integration),
                notice: t('integrations.update.success')
  end

  protected

  def integration
    return @integration ||= Integration.new(integration_params) \
      if %w{create new}.include?(params[:action])

    @integration ||= Integration.find(params[:id])
  end

  def integrations
    @integrations ||= Integration.order { name }.all
  end

  def integration_params
    params
      .require(:integration)
      .permit(:address, :credentials, :integration_type, :name)
  rescue ActionController::ParameterMissing; {}
  end
end
