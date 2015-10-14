module Interface
  module IRely
    module Entity
      class Insert
        def initialize(context, client = nil)
          @context = context
          @client = client
        end

        def call
          result = client.call

          parse_response result.hash_response

          log result
        end

        def client
          @client ||= Interface::IRely::ApiClients::ImportEntity
                      .new(base_url, credentials, data)
        end

        def base_url
          @base_url ||= @context.organization.integration.address
        end

        def credentials
          @credentials ||= Interface::IRely::CredentialParser
            .build(@context.organization.integration.credentials)
        end

        def data
          @data ||= Translate.translate(@context)
        end

        def parse_response(response)
          Parse.new(@context, response).call
        end

        def log(result)
          @context.root_instance.interface_logs << Interface::Log.new(
            action: :insert,
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
end
