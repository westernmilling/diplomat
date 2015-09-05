module Interface
  module Logging
    extend ActiveSupport::Concern

    included do
      def build_log(organization,
                    integration,
                    action,
                    status,
                    interfaceable,
                    message,
                    response = nil,
                    version = nil)
        log = Interface::Log.new
        log.organization = organization
        log.integration = integration
        log.action = action.to_sym
        log.status = status
        log.interfaceable = interfaceable
        log.message = message
        log.version = version || interfaceable._v
        log.interface_response = response
        log
      end

      def create_log!(organization,
                      integration,
                      action,
                      status,
                      interfaceable,
                      message,
                      version = interfaceable._v,
                      response = nil)
        log = build_log(organization,
                        integration,
                        action,
                        status,
                        interfaceable,
                        message,
                        version,
                        response)
        log.save!
        log
      end
    end
  end
end
