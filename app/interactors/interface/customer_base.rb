require_relative 'concerns/logging'

module Interface
  class CustomerBase
    include Interactor
    include Interface::Logging

    delegate :customer, to: :entity
    delegate :entity, to: :context

    def log!(action, customer, result)
      create_log!(
        action,
        result.success? ? :success : :failure,
        customer,
        result.message,
        customer._v,
        result.interface_payload.to_json,
        result.interface_payload[:result]
      )
    end
  end
end
