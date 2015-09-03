module Interface
  module IRely
    class EntityInsert
      include Interactor

      delegate :entity, to: :context

      def call
        hash = translate_entity

        response = connection.post do |request|
          add_headers request

          request.body = [hash].to_json
        end

        convert_response(response.body)
      end

      protected

      # TODO: Consider building translation classes
      def translate_entity
        {
          id: entity.reference.to_i,
          name: entity.name,
          contacts: translated_contacts,
          locations: translated_locations,
          customer: {
            type: entity.entity_type.capitalize,
            creditlimit: 0
          }
          # custom: {
          #   uuid: customer.entity.uuid
          # }
        }
      end

      def translated_contacts
        entity.contacts.map do |contact|
          {
            name: contact.full_name,
            phone: contact.phone_number,
            fax: contact.fax_number,
            mobile: contact.mobile_number,
            email: contact.email_address,
            id: contact.id
          }
        end
      end

      def translated_locations
        entity.locations.map do |location|
          {
            name: location.location_name,
            address: location.street_address,
            city: location.city,
            state: location.region,
            zipcode: location.region_code,
            country: location.country,
            termsId: 'Due on Receipt',
            id: location.id
          }
        end
      end

      def connection
        Faraday.new(url: url)
      end

      def add_headers(request)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] =
          "Bearer #{Figaro.env.IRELY_API_KEY}.#{Figaro.env.IRELY_API_SECRET}"
        request.headers[CaseSensitiveString.new('ICompany')] = irely_company
      end

      def url
        # Accept URL in context, pass in from Organization Integration
        # In production we'll use the integration details, in test we can
        # pull this information from anywhere (Figaro.env).
        "#{Figaro.env.IRELY_BASE_URL}entitymanagement/api/entity/import"
      end

      def irely_company
        # Accept Company in context, pass in from Organization Integration
        # In production we'll use the integration details, in test we can
        # pull this information from anywhere (Figaro.env).
        Figaro.env.IRELY_COMPANY
      end

      def convert_response(body)
        parsed_response = JSON.parse(body.gsub('i21_id', 'interface_id'),
                                     symbolize_names: true)

        context.merge!(
          payload: parsed_response,
          response: body,
          status: parsed_response[:success] == true ? :success : :failure
        )
      end
    end
  end
end
