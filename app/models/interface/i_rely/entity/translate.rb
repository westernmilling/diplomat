module Interface
  module IRely
    module Entity
      class Translate < Interface::IRely::Translate
        def call
          translate(@payload) unless @payload.nil?

          self
        end

        def translate(payload)
          @output.merge!(
            name: payload.name,
            entityNo: payload.reference,
            contacts: translate_klass('Contact').translate(payload.contacts),
            locations: translate_klass('Location').translate(payload.locations),
            customer: translate_klass('Customer').translate(payload.customer)
          )
            .merge!(id(payload))
        end

        def translate_klass(module_translate)
          "::Interface::IRely::#{module_translate}::Translate".constantize
        end
      end
    end
  end
end
