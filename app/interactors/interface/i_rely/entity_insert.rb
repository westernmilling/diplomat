module Interface
  module IRely
    class EntityInsert
      include Interactor

      before :extract_credentials

      delegate :base_url, to: :context
      delegate :credentials, to: :context
      delegate :request, to: :context

      def call
        hash = translate_request

        response = connection.post do |request|
          add_headers request

          Rails.logger.debug "API POST: #{[hash].to_json}"
          request.body = [hash].to_json
        end

        convert_response(response.body)
      end

      protected

      # TODO: Most of the code below this point is shared between the Insert
      #       and the Update actions (refactor/DRY).
      #       Bear in mind the update data has the i21_id, can insert have nils?
      def extract_credentials
        # TODO: Implement and use the Interface::IRely::CredentialParser here
        first_delim = credentials.index(':')
        last_delim = credentials.rindex('@')

        context.api_key = credentials[0, first_delim]
        context.api_secret = credentials[first_delim + 1..last_delim - 1]
        context.company_id = credentials[last_delim + 1..credentials.length]
        # puts "#{context.api_key},#{context.api_secret},#{context.company_id}"
      end

      # TODO: Consider building translation classes
      def translate_request
        {
          id: request[:id],
          # entity_number: request[:reference].to_i,
          name: request[:name],
          contacts: translate_contacts(request[:contacts]),
          locations: translate_locations(request[:locations]),
          customer: translate_customer(request)
        }
      end

      def translate_contacts(request)
        request.map do |contact_request|
          {
            name: contact_request[:name],
            phone: contact_request[:phone_number],
            fax: contact_request[:fax_number],
            mobile: contact_request[:mobile_number],
            email: contact_request[:email_address],
            id: contact_request[:id],
          }
        end
      end

      def translate_locations(request)
        request.map do |location_request|
          {
            name: location_request[:name],
            address: location_request[:street_address],
            city: location_request[:city],
            state: location_request[:region],
            zipcode: location_request[:region_code],
            country: location_request[:country],
            termsId: 'Due on Receipt',
            id: location_request[:id],
          }
        end
      end

      def translate_customer(request)
        return nil if request[:customer].nil?

        {
          type: request[:entity_type].capitalize,
          creditlimit: request[:customer][:credit_limit]
        }
      end

      def connection
        Rails.logger.debug "Creating new Faraday connection with url: #{url}"
        Faraday.new(url: url)
      end

      def add_headers(request)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] =
          "Bearer #{context.api_key}.#{context.api_secret}"
        request.headers[CaseSensitiveString.new('ICompany')] = irely_company
      end

      def url
        "#{context.base_url}entitymanagement/api/entity/import"
      end

      def irely_company
        context.company_id
      end

      def convert_response(body)
        Rails.logger.debug "API response: #{body}"
        # TODO: We should probably convert this into a less iRely bound format
        parsed_response = JSON.parse(body.gsub('i21_id', 'interface_id'),
                                     symbolize_names: true)

        # iRely API response issue hacks here
        hack parsed_response

        context.merge!(
          payload: parsed_response,
          response: body,
          status: parsed_response[:success] ? :success : :failure
        )
      end

      def hack(response)
        if response[:success]
          response[:data][0][:customer][:interface_id] =
            response[:data][0][:interface_id]
        end
      end
    end
  end
end
