# A +Location+ represents a mail address.
class Location < ActiveRecord::Base
  include Disableable

  acts_as_paranoid

  belongs_to :entity, inverse_of: :locations
  has_many :interface_adhesives,
           class_name: Interface::Adhesive,
           foreign_key: :interfaceable_id,
           foreign_type: Location

  validates \
    :cached_long_address,
    :entity,
    :location_name,
    :street_address,
    :city,
    :region,
    :region_code,
    :country,
    :uuid,
    presence: true

  def address_lines
    [street_address, city, region, region_code, country].compact
  end

  def long_address
    address_lines.join(', ')
  end

  def to_s
    decorate.long_address
  end
end
