# Captures information needed to create or update a +User+
class UserEntry < FormEntry
  attribute :email, String
  attribute :name, String
  attribute :is_active, Integer

  validates \
    :email,
    :name,
    presence: true
end
