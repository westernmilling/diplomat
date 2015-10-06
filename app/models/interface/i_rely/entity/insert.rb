module Interface
  module IRely
    # TODO: Build a base API class which includes HTTParty, common initialize
    #       and some common methods, credentials, headers, parse_response
    module Entity
      class Insert < Interface::IRely::Base
        def call
          Rails.logger.debug "Posting to iRely endpoint at #{url}"
          response = self
                     .class
                     .post("#{url}", body: body.to_json, headers: headers)
          Rails.logger.debug "Response from iRely endpoint was #{response}"

          parse_response response
        end

        def body
          return [{}] if @data.nil?

          Interface::IRely::Translators::EntityTranslator.translate([@data])
        end

        def url
          "#{@base_url}/entitymanagement/api/entity/import"
        end

        def parse_response(response)
          # extract the i21_ids
          # puts response.to_snake_keys[:data]
          # Interface::IRely::Parsers::ParseEntityResponse
          #   .parse(@data, response.to_snake_keys)

          { success: false }.merge(response).to_snake_keys
        end
      end
    end
  end
end
