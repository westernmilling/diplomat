module Interface
  module IRely
    module Contact
      class Translate < Interface::IRely::Translate
        def call
          translate(@payload) unless @payload.nil?

          self
        end

        def translate(payload)
          @output.merge!(
            name: payload.full_name,
            phone: payload.phone_number,
            fax: payload.fax_number,
            mobile: payload.mobile_number,
            email: payload.email_address,
          )
            .merge!(id(payload))
            .merge!(row_state(payload))
        end
      end
    end
  end
end
