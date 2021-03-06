class AcceptInviteEntry < FormEntry
  attribute :invitation_token, String
  attribute :name, String
  attribute :password, String
  attribute :password_confirmation, String

  validates \
    :password,
    confirmation: true
  validates \
    :invitation_token,
    :name,
    :password,
    :password_confirmation,
    presence: true
end
