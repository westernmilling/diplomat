module Interface
  module IRely
    module Location
      class Translate < Interface::IRely::Translate
        def call
          translate(@payload) unless @payload.nil?

          self
        end

        def translate(payload)
          @output.merge!(
            name: payload.location_name,
            phone: payload.phone_number,
            fax: payload.fax_number,
            address: payload.street_address,
            city: payload.city,
            state: payload.region,
            zipcode: payload.region_code,
            country: payload.country,
            termsId: 'Due on Receipt',
          )
            .merge!(id(payload))
            .merge!(row_state(payload))
        end
      end
    end
  end
end
