# Admin
module Admin
  # Controller for managing existing users
  class UsersController < ApplicationController
    using Decoration

    before_action -> { authorize :user }, except: [:show]
    before_action -> { authorize user }, only: [:show]
    before_action :decorate_user, only: [:show]

    helper_method :entry, :user, :users
    respond_to :html

    def create
      render :new and return unless entry.valid?

      handle_service_result(invite_user,
                            -> { redirect_to(admin_user_path(user)) },
                            -> { render :new })
    end

    def update
      render :edit and return unless entry.valid?

      handle_service_result(update_user,
                            -> { redirect_to(admin_user_path(user)) },
                            -> { render :edit })
    end

    protected

    def build_user
      User.new(user_params.except(:role_names))
    end

    def entry
      @entry ||= UserEntry
                 .new(user.attributes)
                 .merge_hash(user_params)
    end

    def decorate_user
      @user = user.decorate
    end

    def find_user
      User.find(params[:id])
    end

    def invite_user
      result = InviteUser.call(entry.to_h.merge(current_user: current_user))
      @user = result.user
      result
    end

    def update_user
      result = UpdateUser.call(
        entry.to_h.merge(id: user.id, current_user: current_user))
      @user = result.user
      result
    end

    def user
      @user ||= params[:id] ? find_user : build_user
    end

    def user_params
      params
        .require(:entry)
        .permit(:email, :name, :is_active, role_names: [])
    rescue ActionController::ParameterMissing; {}
    end

    def users
      @users ||= User.all.to_a.decorate_all
    end
  end
end
