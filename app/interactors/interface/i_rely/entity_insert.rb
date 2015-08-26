module Interface
  module IRely
    class EntityInsert
      include Interactor

      delegate :entity, to: :context

      def call
        contacts = entity.contacts.map do |contact|
          {
            name: contact.full_name,
            phone: contact.phone_number,
            fax: contact.fax_number,
            mobile: contact.mobile_number,
            email: contact.email_address,
            id: contact.id
          }
        end
        locations = entity.locations.map do |location|
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
        hash = {
          id: entity.reference.to_i,
          name: entity.name,
          contacts: contacts,
          locations: locations,
          customer: {
            type: entity.entity_type.capitalize,
            creditlimit: 0
          }
          # custom: {
          #   uuid: customer.entity.uuid
          # }
        }

        response = connection.post do |req|
          req.headers['Content-Type'] = 'application/json'
          # TODO: Key and Secret can probably stay in env and not in Integration
          req.headers['Authorization'] = "Bearer #{Figaro.env.IRELY_API_KEY}.#{Figaro.env.IRELY_API_SECRET}"
          # TODO: Move Company into Integration model
          req.headers[CaseSensitiveString.new('ICompany')] = Figaro.env.IRELY_COMPANY
          req.body = [hash].to_json
        end
      end

      protected

      def connection
        Faraday.new(url: url)
      end

      def url
        # TODO: Store base URL in env and remove from Integration
        "#{Figaro.env.IRELY_BASE_URL}entitymanagement/api/entity/import"
      end
    end
  end
end
