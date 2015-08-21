# An entity is a representation of an organization.
#
# Entities can be any kind of organization, customer, vendor, etc.
class Entity < ActiveRecord::Base
  extend Enumerize

  acts_as_paranoid

  belongs_to :parent_entity, class_name: Entity
  has_many :contacts
  has_many :locations, inverse_of: :entity
  has_one :contact

  enumerize :entity_type, in: [:company, :person], default: :company
  enumerize :ten99_form, in: [
    :crop_insurance_proceeds, :direct_sales, :excess_golden_parachute_payments,
    :federal_income_tax_withheld, :fish_boat_proceeds,
    :gross_proceeds_paid_to_an_attorney, :medical_and_health_care_payments,
    :non_employee_compensation, :other_income, :rents, :royalties,
    :subsitute_payments_in_lieu_of_dividends_or_interest
  ]
  enumerize :ten99_type, in: [:none, :ten99_misc, :ten99_int, :ten99_b]

  validates \
    :entity_type,
    :name,
    :cached_long_name,
    :reference,
    :uuid,
    presence: true
  validates :reference, uniqueness: true

  def active?
    is_active == 1
  end

  def to_s
    name
  end
end
