class UpdateUser
  include Interactor

  before :check_user_details
  before :find_user

  def call
    User.transaction do
      context.user.update_attributes(user_params)
      context.user.save!
    end
    context.message = I18n.t('users.update.success')
  end

  def user_params
    {
      email: context.email,
      name: context.name,
      is_active: context.is_active || 1
    }
  end

  protected

  def check_user_details
    return if context.email.present? && \
              context.name.present? && \
              context.email =~ /.+@.+\..+/i

    context.fail!(message: I18n.t('users.update.invalid'))
  end

  def find_user
    context.user = User.find(context.id)
  end
end
