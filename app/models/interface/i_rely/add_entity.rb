module Interface
  module IRely
    class AddEntity
      def initialize(integration)
        @base_url = integration.base_url
        @credentials = IRely::Credentials.new

        IRely::CredentialParser
          .new(integration.credentials)
          .parse_into @credentials
      end

      # def initialize(base_url, credentials)
      #   @base_url = base_url
      #   @credentials = credentials
      # end

      def self.call(integration, payload)
        # TODO: Clean this up
        # credentials = IRely::Credentials.new
        # IRely::CredentialParser
        #   .new(integration.credentials)
        #   .parse_into credentials

        # new(integration.base_url, credentials).run(payload)
        new(integration).run(payload)
      end

      protected

      def run(payload)
        connection.put do |request|
          request.body = build_data.to_json
          Rails.logger.debug "API POST: #{request.body}"
        end
      end

      def connection
        Faraday.new(url: url, headers: headers)
      end

      def url
        "#{base_url}entitymanagement/api/entity/import"
      end

      def headers(request)
        {
          'Content-Type': 'application/json'
          'Authorization':
            "Bearer #{credentials.api_key}.#{credentials.api_secret}"
          CaseSensitiveString.new('ICompany'): credentials.company_id
        }
      end

      def build_data
        # Convert the payload
        # - i21_ids, rowState and other attribute translations
        []
      end
    end
  end
end
