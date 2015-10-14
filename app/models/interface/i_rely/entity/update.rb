module Interface
  module IRely
    module Entity
      class Update < Interface::IRely::Base
        def call
          result = client.call

          parse_response result.hash_response

          log(:update, result)
        end

        def client
          @client ||= Interface::IRely::ApiClients::SyncEntity
                      .new(base_url, credentials, data)
        end

        def data
          @data ||= Translate.translate(@context)
        end

        def parse_response(response)
          Parse.new(@context, response).call
        end
      end
    end
  end
end
