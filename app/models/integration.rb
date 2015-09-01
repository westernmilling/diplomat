class Integration < ActiveRecord::Base
  extend Enumerize

  after_initialize :ensure_uuid_present

  enumerize :integration_type, in: ['i_rely', 'i_rely/obfuscated', 'test']
  has_many :organizations

  validates \
    :address,
    :credentials,
    :integration_type,
    :name,
    :uuid,
    presence: true

  def interface_namespace
    Object.const_get("interface/#{integration_type}".camelize)
  end

  def to_s
    name
  end

  protected

  def ensure_uuid_present
    self.uuid ||= UUID.generate(:compact)
  end
end
