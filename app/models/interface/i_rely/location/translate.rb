module Interface
  module IRely
    module Location
      class Translate < Interface::IRely::Translate
        def call
          translate unless @context.nil?

          self
        end

        def translate
          @output.merge!(
            name: @context.root_instance.location_name,
            phone: @context.root_instance.phone_number,
            fax: @context.root_instance.fax_number,
            address: @context.root_instance.street_address,
            city: @context.root_instance.city,
            state: @context.root_instance.region,
            zipcode: @context.root_instance.region_code,
            country: @context.root_instance.country,
            termsId: 'Due on Receipt',
          )
            .merge!(id)
            .merge!(row_state)
        end
      end
    end
  end
end
