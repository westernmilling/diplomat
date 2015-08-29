module Interface
  class CustomerUpdate < CustomerBase
    delegate :customer, to: :entity
    delegate :entity, to: :context
    delegate :integration, to: :context

    def call
      result = invoke_external_interface!

      context.interface_log = log!(:update, customer, result)
      context.merge!(
        result.to_h.slice(:interface_payload, :interface_result)
      )
      context.message = I18n.t('customer_update.success')
    end

    protected

    def invoke_external_interface!
      interface_class(integration)
        .call(entity: entity,
              interface_identifier: context.interface_identifier)
    end

    def interface_class(integration)
      parts = [
        'Interface', integration.integration_type, 'EntityUpdate'
      ]
      Object.const_get(parts.join('::'))
    end
  end
end
