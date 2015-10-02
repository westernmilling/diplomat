module Interface
  module IRely
    # TODO: Build a base API class which includes HTTParty, common initialize
    #       and some common methods, credentials, headers, parse_response
    module Entity
      class Insert
        include HTTParty

        def initialize(base_url, credentials, data)
          @base_url = base_url
          @credentials = credentials
          @data = data
        end

        def call
          Rails.logger.debug "Posting to iRely endpoint at #{url}"
          puts body
          response = self
                     .class
                     .post("#{url}", body: body.to_json, headers: headers)
          Rails.logger.debug "Response from iRely endpoint was #{response}"
          parse_response response
        end

        def credentials
          @credentials ||= Interface::IRely::Credentials.new
        end

        def body
          return [{}] if @data.nil?

          Interface::IRely::Translators::EntityTranslator.translate([@data])
        end

        def headers
          {
            'Content-Type' => 'application/json',
            'Authorization' =>
              "Bearer #{credentials.api_key}.#{credentials.api_secret}",
            CaseSensitiveString.new('ICompany') => credentials.company_id || ''
          }
        end

        def url
          "#{@base_url}/entitymanagement/api/entity/import"
        end

        def parse_response(response)
          { success: false }.merge(response).to_snake_keys
        end
      end
    end
  end
end
