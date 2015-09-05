class Interface::Log < ActiveRecord::Base
  extend Enumerize

  self.table_name = 'interface_logs'

  belongs_to :integration
  belongs_to :organization
  belongs_to :interfaceable, polymorphic: true

  enumerize :action, in: [:insert, :skipped, :update]
  enumerize :status, in: [:failure, :success]

  validates \
    :interfaceable,
    presence: true

  # class << self
  #   def build_new(organization,
  #                 integration,
  #                 action,
  #                 status,
  #                 interfaceable,
  #                 message,
  #                 version,
  #                 interface_response = nil,
  #                 interface_status = nil)
  #     log = Interface::Log.new
  #     log.organization = organization
  #     log.integration = integration
  #     log.action = action
  #     log.status = status
  #     log.interfaceable = interfaceable
  #     log.message = message
  #     log.version = version
  #     log.interface_response = interface_response
  #     log.interface_status = interface_status
  #     log
  #   end
  # end
end
