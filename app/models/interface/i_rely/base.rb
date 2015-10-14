module Interface
  module IRely
    class Base
      def initialize(context, client = nil)
        @context = context
        @client = client
      end

      def base_url
        @base_url ||= @context.organization.integration.address
      end

      def credentials
        @credentials ||= Interface::IRely::CredentialParser
          .build(@context.organization.integration.credentials)
      end

      def log(action, result)
        @context.root_instance.interface_logs << Interface::Log.new(
          action: action,
          integration: @context.organization.integration,
          interfaceable: @context.root_instance,
          interface_response: result.raw_response.to_s,
          message: result.message,
          organization: @context.organization,
          status: result.success ? :success : :failure,
          version: @context.root_instance._v
        )
      end
    end
  end
end
