module Interface
  module Logging
    extend ActiveSupport::Concern

    included do
      def create_log!(action,
                      status,
                      interfaceable,
                      message,
                      version = interfaceable._v,
                      interface_payload = nil,
                      interface_status = nil)
        log = Interface::Log.build_new(action,
                                       status,
                                       interfaceable,
                                       message,
                                       version,
                                       interface_payload,
                                       interface_status)
        log.save!
        log
      end
    end
  end
end
