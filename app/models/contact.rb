# A +Contact+ represents that contact details for an +Entity+
class Contact < ActiveRecord::Base
  include Disableable

  acts_as_paranoid

  belongs_to :entity

  validates \
    :entity,
    :first_name,
    :last_name,
    :is_active,
    :uuid,
    presence: true

  def to_s
    display_name
  end
end
