class Interface::Log < ActiveRecord::Base
  extend Enumerize

  self.table_name = 'interface_logs'

  belongs_to :integration
  belongs_to :organization
  belongs_to :interfaceable, polymorphic: true

  enumerize :action, in: [:insert, :skipped, :update]
  enumerize :status, in: [:failure, :success]

  class << self
    def build_new(action,
                  status,
                  interfaceable,
                  message,
                  version,
                  interface_payload = nil,
                  interface_status = nil)
      log = Interface::Log.new
      log.action = action
      log.status = status
      log.interfaceable = interfaceable
      log.message = message
      log.version = version
      log.interface_payload = interface_payload
      log.interface_status = interface_status
      log
    end
  end
end
