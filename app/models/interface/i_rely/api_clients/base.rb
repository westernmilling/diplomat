module Interface
  module IRely
    module ApiClients
      class Base
        include HTTParty

        def initialize(base_url, credentials, data)
          @base_url = base_url
          @credentials = credentials
          @data = data
        end

        def body
          return [{}] if @data.nil?

          @data
        end

        def credentials
          @credentials ||= Interface::IRely::Credentials.new
        end

        def headers
          {
            'Content-Type' => 'application/json',
            'Authorization' =>
              "Bearer #{credentials.api_key}.#{credentials.api_secret}",
            CaseSensitiveString.new('ICompany') => credentials.company_id || ''
          }
        end
      end
    end
  end
end
