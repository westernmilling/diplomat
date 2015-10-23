# Represents the +Vendor+ trait for an +Entity+.
class Vendor < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :entity

  validates \
    :entity,
    :uuid,
    presence: true
  validates :is_active, inclusion: 0..1

  def active?
    is_active == 1
  end

  def to_s
    entity.display_name
  end
end
