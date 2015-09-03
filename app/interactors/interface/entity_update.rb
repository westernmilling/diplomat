module Interface
  class EntityUpdate < CustomerBase
    delegate :entity, to: :context
    delegate :integration, to: :context

    def call
      result = invoke_external_interface!

      context.log = log!(:update, entity, result)
      context.merge!(
        result.to_h.slice(:payload, :response, :result)
      )
      context.message = I18n.t('entity_update.success')
    end

    protected

    def invoke_external_interface!
      interface_class(integration)
        .call(entity: entity,
              identifier: context.identifier)
    end

    def interface_class(integration)
      parts = [
        integration.interface_namespace, 'EntityUpdate'
      ]
      Object.const_get(parts.join('::'))
    end
  end
end
