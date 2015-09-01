module Interface
  module IRely
    class EntityInsert
      include Interactor

      delegate :entity, to: :context

      def call
        hash = translate_entity

        response = connection.post do |request|
          prepare_headers request

          request.body = [hash].to_json
        end

        extract_response(response.body)
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

      def prepare_headers(request)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] =
          "Bearer #{Figaro.env.IRELY_API_KEY}.#{Figaro.env.IRELY_API_SECRET}"
        request.headers[CaseSensitiveString.new('ICompany')] = irely_company
      end

      def url
        # TODO: Store base URL in env and remove from Integration
        "#{Figaro.env.IRELY_BASE_URL}entitymanagement/api/entity/import"
      end

      def irely_company
        # TODO: Move Company into Integration model
        Figaro.env.IRELY_COMPANY
      end

      def extract_response(body)
        body = JSON.parse(body, symbolize_names: true)

        context.merge!(
          payload: body,
          status: body[:success] == true ? :success : :failure
        )
        if body[:success] && body[:data].any?
          context[:identifier] = body[:data][0][:i21_id]
        end
      end
    end
  end
end
