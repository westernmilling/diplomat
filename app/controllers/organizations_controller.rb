class OrganizationsController < ApplicationController
  # before_action -> { authorize :organization }, except: [:show]
  # before_action -> { authorize organization }, only: :show

  def index; end

  def show; end

  def organization
    return @organization ||= Organization.new(organization_params) \
      if %w{create new}.include?(params[:action])

    @organization ||= Organization.find(params[:id])
  end

  def organizations
    @organizations ||= Organization.order { name }
  end

  helper_method :organization, :organizations
end
