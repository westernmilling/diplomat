module Interface
  module IRely
    module Entity
      class Update < Interface::IRely::Base
        def call
          Rails.logger.debug "Putting to iRely endpoint at #{url}"
          response = self
                     .class
                     .put("#{url}", body: body.to_json, headers: headers)
          Rails.logger.debug "Response from iRely endpoint was #{response}"

          parse_response response.to_snake_keys
        end

        def body
          return [{}] if @data.nil?

          Interface::IRely::Entity::Translate.translate([@data])
        end

        def url
          "#{@base_url}/entitymanagement/api/entity/sync"
        end

        def parse_response(response)
          Interface::IRely::Entity::Parse.new(@data, response).call

          { success: false }.merge(response)
        end
      end
    end
  end
end
