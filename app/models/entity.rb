# An entity is a representation of an organization.
#
# Entities can be any kind of organization, customer, vendor, etc.
class Entity < ActiveRecord::Base
  extend Enumerize

  acts_as_paranoid
  after_commit :queue_upsert

  belongs_to :parent_entity, class_name: Entity
  has_many :contacts
  has_many :locations, inverse_of: :entity
  has_many :interface_states,
           class_name: Interface::State,
           foreign_key: :interfaceable_id,
           foreign_type: Entity
  has_many :interface_logs,
           class_name: Interface::Log,
           foreign_key: :interfaceable_id,
           foreign_type: Entity
  has_one :contact, autosave: false
  has_one :customer, autosave: false

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

  def organizations(related_trait = nil)
    query = OrganizationEntity
            .where { entity_id == my { id } }

    query = query.where { trait == my { related_trait } } if related_trait
    query.map(&:organization)
  end

  def to_s
    name
  end

  protected

  def queue_upsert
    EntityUpsertWorker.perform_async(id, _v)
  end
end
