module Users
  class InvitationsController < Devise::InvitationsController
    before_action :build_accept_entry, only: [:edit, :update]
    prepend_before_filter :resource_from_invitation_token,
                          only: [:destroy, :edit, :update]

    def edit
      resource.invitation_token = params[:invitation_token]
      @entry.name = resource.name
      @entry.invitation_token = resource.invitation_token
    end

    # rubocop:disable Metrics/AbcSize
    def update
      return render :edit unless @entry.valid?

      result = AcceptUserInvite.call(@entry.to_h)

      self.resource = result.invited_user

      if result.success?
        if Devise.allow_insecure_sign_in_after_accept
          if resource.active_for_authentication?
            flash_message = :updated
          else
            flash_message = :updated_not_active
          end
          set_flash_message :notice, flash_message if is_flashing_format?
          sign_in(resource_name, resource)
          respond_with resource, location: after_accept_path_for(resource)
        else
          set_flash_message :notice, :updated_not_active if is_flashing_format?
          respond_with resource, location: new_session_path(resource_name)
        end
      else
        resource.invitation_token = invitation_token
        respond_with_navigational(resource) { render :edit }
      end
    end
    # rubocop:enable Metrics/AbcSize

    protected

    def build_accept_entry
      @entry = AcceptInviteEntry.new(accept_params)
    end

    def accept_params
      params
        .require(:entry)
        .permit(:name, :password, :password_confirmation, :invitation_token)
    rescue ActionController::ParameterMissing; {}
    end

    def find_resource_by_token
      resource_class.find_by_invitation_token(invitation_token, true)
    end

    def invitation_token
      params[:invitation_token] || accept_params[:invitation_token]
    end

    def resource_from_invitation_token
      unless invitation_token && self.resource = find_resource_by_token
        set_flash_message(:alert, :invitation_token_invalid) \
          if is_flashing_format?
        redirect_to after_sign_out_path_for(resource_name)
      end
    end
  end
end
