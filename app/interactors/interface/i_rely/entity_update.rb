module Interface
  module IRely
    class EntityUpdate
      include Interactor

      before :extract_credentials

      delegate :base_url, to: :context
      delegate :credentials, to: :context
      delegate :request, to: :context

      def call
        hash = translate_request

        response = connection.put do |request|
          add_headers request

          Rails.logger.debug "API PUT: #{[hash].to_json}"
          request.body = [hash].to_json
        end

        convert_response(response.body)
      end

      protected

      def extract_credentials
        first_delim = credentials.index(':')
        last_delim = credentials.rindex('@')

        context.api_key = credentials[0, first_delim]
        context.api_secret = credentials[first_delim + 1..last_delim - 1]
        context.company_id = credentials[last_delim + 1..credentials.length]
      end

      # TODO: Consider building translation classes
      def translate_request
        {
          # NB: No entity number since no provision in the API yet
          # entity_number: request[:reference].to_i,
          name: request[:name],
          contacts: translate_contacts(request[:contacts]),
          # NB: No locations in update due to issues with iRely API
          # locations: translate_locations(request[:locations]),
          # customer: translate_customer(request)
          locations: [],
          customer: translate_customer(request)
          # customer: {}
        }.merge(id(request))
      end

      def translate_contacts(request)
        request.map do |contact_request|
          {
            name: contact_request[:name],
            phone: contact_request[:phone_number],
            fax: contact_request[:fax_number],
            mobile: contact_request[:mobile_number],
            email: contact_request[:email_address]
          }.merge(id(contact_request))
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
            termsId: 'Due on Receipt'
          }.merge(id(location_request))
        end
      end

      def translate_customer(request)
        return nil if request[:customer].nil?

        {
          type: request[:entity_type].capitalize,
          creditlimit: request[:customer][:credit_limit]
        }.merge(id(request[:customer]))
      end

      def id(element)
        if element[:interface_id].present?
          { i21_id: element[:interface_id] }
        else
          { id: element[:id] }
        end
      end

      def connection
        Faraday.new(url: url)
      end

      def add_headers(request)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] =
          "Bearer #{context.api_key}.#{context.api_secret}"
        request.headers[CaseSensitiveString.new('ICompany')] = irely_company
      end

      def url
        "#{context.base_url}entitymanagement/api/entity/sync"
      end

      def irely_company
        context.company_id
      end

      def convert_response(body)
        Rails.logger.debug "API response: #{body}"
        # TODO: We should probably convert this into a less iRely bound format
        parsed_response = JSON.parse(body.gsub('i21_id', 'interface_id'),
                                     symbolize_names: true)

        context.merge!(
          payload: parsed_response,
          response: body,
          status: parsed_response[:success] ? :success : :failure
        )
      end
    end
  end
end
