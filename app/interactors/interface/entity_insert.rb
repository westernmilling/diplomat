module Interface
  class EntityInsert
    include Interactor

    delegate :request, to: :context
    delegate :integration, to: :context

    def call
      result = invoke_external_interface!

      context.merge!(result.to_h.slice(:payload, :response, :status))

      context.message = I18n.t("entity_insert.#{result.status}")
    end

    protected

    def invoke_external_interface!
      interface_class(integration)
        .call(base_url: integration.address,
              credentials: integration.credentials,
              request: request)
    end

    def interface_class(integration)
      parts = [
        integration.interface_namespace, 'EntityInsert'
      ]
      Object.const_get(parts.join('::'))
    end
  end
end
