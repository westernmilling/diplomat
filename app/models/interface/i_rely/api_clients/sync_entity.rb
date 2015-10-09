module Interface
  module IRely
    module ApiClients
      class SyncEntity < Base
        def call
          Rails.logger.debug "PUTing to iRely endpoint at #{url}"
          response = self
                     .class
                     .put("#{url}", body: body.to_json, headers: headers)
          Rails.logger.debug "Response from iRely endpoint was #{response}"

          Result.new(response.parsed_response)
        end

        def url
          "#{@base_url}/entitymanagement/api/entity/sync"
        end
      end
    end
  end
end
