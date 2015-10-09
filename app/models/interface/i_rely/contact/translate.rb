module Interface
  module IRely
    module Contact
      class Translate < Interface::IRely::Translate
        def call
          translate unless @context.nil?

          self
        end

        def translate
          @output.merge!(
            name: @context.root_instance.full_name,
            phone: @context.root_instance.phone_number,
            fax: @context.root_instance.fax_number,
            mobile: @context.root_instance.mobile_number,
            email: @context.root_instance.email_address,
          )
            .merge!(id)
            .merge!(row_state)
        end
      end
    end
  end
end
