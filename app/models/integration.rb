class Integration < ActiveRecord::Base
  after_initialize :ensure_uuid_present

  has_many :organizations

  validates \
    :address,
    :credentials,
    :integration_type,
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
