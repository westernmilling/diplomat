module Interface
  class LogVessel
    def initialize
      @logs = []
    end

    def add(organization,
            integration,
            action,
            status,
            interfaceable,
            message,
            version,
            interface_payload = nil,
            interface_status = nil)
      log = Interface::Log.new
      log.organization = organization
      log.integration = integration
      log.action = action
      log.status = status
      log.interfaceable = interfaceable
      log.message = message
      log.version = version
      log.interface_payload = interface_payload
      log.interface_status = interface_status
      @logs << log
      log
    end
  end
end
