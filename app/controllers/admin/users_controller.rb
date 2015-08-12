# Admin
module Admin
  # Controller for managing existing users
  class UsersController < ApplicationController
    using Decoration

    respond_to :html

    before_action :find_user, only: [:destroy, :edit, :show, :update]
    before_action :build_user_entry, only: [:edit, :update]
    before_action :decorate_user, only: [:show]

    def edit; end

    def index
      @users = users.decorate_all
    end

    def show; end

    def update
      return render :edit unless @user_entry.valid?

      if @user.update_attributes(user_hash)
        redirect_to(admin_user_path(@user),
                    notice: t('user.update.success'))
      else
        flash[:alert] = t('user.update.failure')
        render :edit
      end
    end

    protected

    def build_user_entry
      hash =
        @user
        .attributes
        .symbolize_keys
        .slice(:name, :is_active)
      @user_entry = UserEntry.new(hash.merge(user_params))
    end

    def decorate_user
      @user = @user.decorate
    end

    def find_user
      @user = User.find(params[:id])
    end

    def user_hash
      @user_entry
        .to_h
        .slice(:name, :is_active)
    end

    def user_params
      params
        .require(:user_entry)
        .permit(:name, :is_active)
    rescue ActionController::ParameterMissing; {}
    end

    def users
      User.all.to_a
    end
  end
end
