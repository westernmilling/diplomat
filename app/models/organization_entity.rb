class OrganizationEntity < ActiveRecord::Base
  acts_as_paranoid
  after_initialize :ensure_uuid_present

  belongs_to :entity
  belongs_to :organization

  validates \
    :entity_id,
    :organization_id,
    :trait,
    :uuid,
    presence: true
  validates \
    :entity_id,
    uniqueness: { scope: [:organization_id, :trait, :deleted_at] }
  validates :uuid, uniqueness: true

  protected

  def ensure_uuid_present
    self.uuid ||= UUID.generate(:compact)
  end
end
