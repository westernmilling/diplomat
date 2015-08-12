class InviteUser
  include Interactor

  before :check_invite_details

  def call
    context.invited_user = User.invite!(invite_params, context.current_user)
    context.message = I18n.t('user.invite.success')
  end

  def invite_params
    {
      email: context.email,
      name: context.name
    }
  end

  protected

  def check_invite_details
    return if context.email.present? && \
              context.name.present? && \
              context.email =~ /.+@.+\..+/i

    context.fail!(message: I18n.t('user.invite.invalid'))
  end
end
