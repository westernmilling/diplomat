class Admin::OrganizationsController < ApplicationController
  before_action -> { authorize :organization }, except: [:show]
  before_action -> { authorize organization }, only: :show

  helper_method :integrations, :organization, :organizations

  def update
    render :edit and return unless \
      organization.update_attributes(organization_params)

    redirect_to(admin_organization_path(organization),
                notice: t('organizations.update.success'))
  end

  protected

  def integrations
    @integrations ||= Integration.order { name }.to_a
  end

  def organization
    return @organization ||= Organization.new(organization_params) \
      if %w{create new}.include?(params[:action])

    @organization ||= Organization.find(params[:id])
  end

  def organizations
    @organizations ||= Organization.order { name }
  end

  def organization_params
    params
      .require(:organization)
      .permit(:integration_id)
  rescue ActionController::ParameterMissing; {}
  end
end
