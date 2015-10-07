module Interface
  module IRely
    module Contact
      class Translate < Interface::IRely::Translate
        def call
          translate(@object) unless @object.nil?

          self
        end

        def translate(object)
          @output.merge!(
            name: object.full_name,
            phone: object.phone_number,
            fax: object.fax_number,
            mobile: object.mobile_number,
            email: object.email_address,
          )
            .merge!(id(object))
            .merge!(row_state(object))
        end
      end
    end
  end
end
