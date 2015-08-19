# Role
class Role < ActiveRecord::Base
  ROLE_NAMES = %w(
    admin
    authenticated
  )
  # rubocop:disable HasAndBelongsToMany
  has_and_belongs_to_many :users, join_table: :users_roles
  # rubocop:enable HasAndBelongsToMany
  belongs_to :resource, polymorphic: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
