module Interface
  class EntityInsert < CustomerBase
    delegate :entity, to: :context
    delegate :integration, to: :context

    def call
      result = invoke_external_interface!

      context.interface_log = log!(:insert, entity, result)
      context.merge!(
        result.to_h.slice(:identifier, :payload, :result)
      )
      context.message = I18n.t('entity_insert.success')
    end

    protected

    def invoke_external_interface!
      interface_class(integration).call(entity: entity)
    end

    def interface_class(integration)
      parts = [
        integration.interface_namespace, 'EntityInsert'
      ]
      Object.const_get(parts.join('::'))
    end
  end
end