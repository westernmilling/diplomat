module Interface
  module IRely
    module Entity
      class Insert #< Interface::IRely::Base
        def initialize(context, client = nil)
          @context = context
          @client = client
        end

        def call
          result = client.call


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

        # def parse_response(response)
        #   Interface::IRely::Entity::Parse.new(@data, response).call
        #
        #   { success: false }.merge(response)
        # end
      end
    end
  end
end
