# Captures information needed to create or update a +User+
class UserEntry < FormEntry
  attribute :email, String
  attribute :name, String
  attribute :is_active, Integer
  attribute :role_names, Array

  validates \
    :email,
    :name,
    presence: true
end
