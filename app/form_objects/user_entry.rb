# Captures information needed to update an existing +User+
class UserEntry < FormEntry
  attribute :name, String
  attribute :is_active, Integer

  validates \
    :name,
    presence: true
end
