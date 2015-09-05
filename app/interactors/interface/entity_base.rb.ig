module Interface
  class EntityBase
    include Interactor
    include Interface::Logging

    delegate :entity, to: :context
    delegate :integration, to: :context

    # def log(action, interfaceable, result)
    #   create_log(
    #     nil,
    #     integration,
    #     action,
    #     result.status,
    #     entity,
    #     result.message,
    #     entity._v,
    #     result.response,
    #     result.payload[:result]
    #   )
    # end
  end
end
