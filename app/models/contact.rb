# A +Contact+ represents that contact details for an +Entity+
class Contact < ActiveRecord::Base
  include Disableable

  acts_as_paranoid

  belongs_to :entity
  has_many :interface_object_maps,
           class_name: Interface::ObjectMap,
           foreign_key: :interfaceable_id,
           foreign_type: Contact

  validates \
    :entity,
    :full_name,
    :uuid,
    presence: true

  def to_s
    full_name
  end
end
