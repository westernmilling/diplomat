module Interface
  module IRely
    module Entity
      class Insert < Interface::IRely::Base
        def call
          Rails.logger.debug "Posting to iRely endpoint at #{url}"
          response = self
                     .class
                     .post("#{url}", body: body.to_json, headers: headers)
          Rails.logger.debug "Response from iRely endpoint was #{response}"

          parse_response response.to_snake_keys
        end

        def body
          return [{}] if @data.nil?

          Interface::IRely::Entity::Translate.translate([@data])
        end

        def url
          "#{@base_url}/entitymanagement/api/entity/import"
        end

        def parse_response(response)
          Interface::IRely::Entity::Parse.new(@data, response).call

          { success: false }.merge(response)
        end
      end
    end
  end
end
