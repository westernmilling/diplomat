module Interface
  class CustomerUpdate < CustomerBase
    delegate :customer, to: :entity
    delegate :entity, to: :context
    delegate :integration, to: :context

    def call
      result = invoke_external_interface!

      context.interface_log = log!(:update, customer, result)
      context.merge!(
        result.to_h.slice(:identifier, :payload, :result)
      )
      context.message = I18n.t('customer_update.success')
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
