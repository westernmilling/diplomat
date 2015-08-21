# Represents the +Salesperson+ trait details for an +Entity+.
class Salesperson < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :entity

  scope :active, -> { unscoped.where(is_active: 1) }

  validates \
    :entity,
    :uuid,
    presence: true

  def active?
    is_active == 1 ? true : false
  end

  def to_s
    entity.name
  end
end
