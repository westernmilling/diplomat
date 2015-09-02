module Interface
  class EntityBase
    include Interactor
    include Interface::Logging

    delegate :entity, to: :context
    delegate :integration, to: :context

    def log( action, v, result)
      create_log(
        nil,
        integration,
        action,
        result.success? ? :success : :failure,
        entity,
        result.message,
        entity._v,
        result.payload.to_json,
        result.payload[:result]
      )
    end
  end
end
