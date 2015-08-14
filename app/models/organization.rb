# Represents an owned and managed tax id.
class Organization < ActiveRecord::Base
  acts_as_paranoid
  after_initialize :ensure_uuid_present

  validates \
    :name,
    :uuid,
    presence: true

  def to_s
    name
  end

  protected

  def ensure_uuid_present
    self.uuid ||= UUID.generate(:compact)
  end
end
