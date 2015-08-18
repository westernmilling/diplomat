class InviteUser
  include Interactor

  before :check_invite_details

  def call
    User.transaction do
      context.user = build_user
      context.user.invite!(context.current_user)
      context.user.save!
    end
    context.message = I18n.t('users.create.success')
  end

  def build_user
    User.new(invite_params) do |user|
      (context.roles || []).each { |role| user.grant role }
    end
  end

  def invite_params
    {
      email: context.email,
      name: context.name,
      is_active: context.is_active || 1
    }
  end

  protected

  def check_invite_details
    return if context.email.present? && \
              context.name.present? && \
              context.email =~ /.+@.+\..+/i

    context.fail!(message: I18n.t('users.create.invalid'))
  end
end
