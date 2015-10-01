module Interface
  module IRely
    module Entity
      class Insert
        include HTTParty

        def initialize(base_url, credentials, data)
          @base_url = base_url
          @credentials = credentials
          @data = data
        end

        def call
          self.class.post("#{@base_url}")#, body: body, headers: headers)
        end

        def credentials
          @credentials ||= Interface::IRely::Credentials.new
        end

        def body
          {}
        end

        def headers
          {
            'Content-Type': 'application/json',
            'Authorization':
              "Bearer #{credentials.api_key}.#{credentials.api_secret}",
            CaseSensitiveString.new('ICompany') => credentials.company_id
          }
        end
      end
    end
  end
end
