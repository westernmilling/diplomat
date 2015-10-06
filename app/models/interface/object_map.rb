class Interface::ObjectMap < ActiveRecord::Base
  self.table_name = 'interface_object_maps'

  belongs_to :integration
  belongs_to :interfaceable, polymorphic: true
  belongs_to :organization

  validates \
    :integration,
    :interface_id,
    :interfaceable,
    :organization,
    :version,
    presence: true
end
