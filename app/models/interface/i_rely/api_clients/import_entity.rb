module Interface
  module IRely
    module ApiClients
      class ImportEntity < Base
        def call
          Rails.logger.debug "Posting to iRely endpoint at #{url}"
          response = self
                     .class
                     .post("#{url}", body: body.to_json, headers: headers)
          Rails.logger.debug "Response from iRely endpoint was #{response}"

          Result.new(response.parsed_response)
        end

        def url
          "#{@base_url}/entitymanagement/api/entity/import"
        end
      end
    end
  end
end
