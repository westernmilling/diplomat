# Represents the +Customer+ trait details for an +Entity+
class Customer < ActiveRecord::Base
  acts_as_paranoid
  after_commit :queue_upsert

  belongs_to :bill_to_location, class_name: Location
  belongs_to :contact
  belongs_to :entity
  belongs_to :location
  belongs_to :parent_customer, class_name: Customer
  belongs_to :salesperson
  belongs_to :ship_to_location, class_name: Location
  has_many :interface_states, class_name: Interface::State, as: :interfaceable

  validates \
    :entity,
    :bill_to_location,
    :ship_to_location,
    :uuid,
    presence: true

  def active?
    is_active == 1 ? true : false
  end

  def to_s
    entity.display_name
  end

  protected

  def queue_upsert
    EntityUpsertWorker.perform_async(entity_id, _v)
  end
end
