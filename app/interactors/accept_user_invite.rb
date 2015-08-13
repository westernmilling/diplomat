class AcceptUserInvite
  include Interactor

  before :check_invite_details
  before :find_invited_user

  def call
    context.invited_user = User.accept_invitation!(
      invitation_token: context.invitation_token,
      name: context.name,
      password: context.password,
      password_confirmation: context.password_confirmation)

    context.message = I18n.t('user.invite.accepted')
  end

  protected

  def check_invite_details
    return if context.name.present? && \
              valid_password? &&
              context.invitation_token.present?

    context.fail!(message: I18n.t('user.invite.invalid'))
  end

  def find_invited_user
    context.invited_user = User
      .find_by_invitation_token(context.invitation_token, false)
  end

  def valid_password?
    context.password.present? && \
      context.password_confirmation.present? && \
      context.password == context.password_confirmation
  end
end
