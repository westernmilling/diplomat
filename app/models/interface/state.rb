class Interface::State < ActiveRecord::Base
  extend Enumerize

  self.table_name = 'interface_states'

  belongs_to :integration
  belongs_to :organization
  belongs_to :interfaceable, polymorphic: true

  validates \
    :interfaceable,
    :integration,
    :organization,
    :version,
    presence: true
end
