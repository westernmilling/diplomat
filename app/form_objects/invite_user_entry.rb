class InviteUserEntry
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :email, String
  attribute :name, String

  validates \
    :email,
    :name,
    presence: true
end
