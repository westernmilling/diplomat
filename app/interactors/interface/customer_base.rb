module Interface
  class CustomerBase
    include Interactor
    include Interface::Logging

    delegate :customer, to: :entity
    delegate :entity, to: :context
    delegate :integration, to: :context

    def log!(action, customer, result)
      create_log!(
        nil,
        integration,
        action,
        result.success? ? :success : :failure,
        customer,
        result.message,
        customer._v,
        result.payload.to_json,
        result.payload[:result]
      )
    end
  end
end
