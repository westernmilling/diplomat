class UpdateUser
  include Interactor

  before :check_user_details
  before :find_user

  delegate :user, to: :context

  def call
    user.with_lock do
      update_user
      grant_roles!
      revoke_roles!
      user.save!
    end
    context.message = I18n.t('users.update.success')
  end

  protected

  def grant_roles!
    ((context.role_names || []) - user.roles.map(&:name)).each do |role|
      user.grant role
    end
  end

  def revoke_roles!
    (user.roles.map(&:name) - (context.role_names || [])).each do |role|
      user.revoke role
    end
  end

  def update_user
    user.update_attributes(user_params)
  end

  def user_params
    { is_active: 1 }.merge(context.to_h.slice(:email, :name, :is_active))
  end

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
