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

  protected

  def build_user
    User.new(user_params) do |user|
      (context.role_names || []).reject(&:blank?).each do |role|
        user.grant role
      end
    end
  end

  def user_params
    { is_active: 1 }.merge(context.to_h.slice(:email, :name, :is_active))
  end

  def check_invite_details
    return if context.email.present? && \
              context.name.present? && \
              context.email =~ /.+@.+\..+/i

    context.fail!(message: I18n.t('users.create.invalid'))
  end
end
