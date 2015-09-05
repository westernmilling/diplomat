module Interface
  class LogManager
    def initialize(organization, integration)
      @organization = organization
      @integration = integration
      @logs = []
    end

    def add(action,
            status,
            interfaceable,
            message,
            response = nil,
            version = interfaceable._v)
      log = Interface::Log.new
      log.organization = @organization
      log.integration = @integration
      log.action = action.to_sym
      log.status = status
      log.interfaceable = interfaceable
      log.message = message
      log.version = version
      log.interface_response = response
      log
    end

    def persist!
      @logs.each &:save!
    end
  end
end
