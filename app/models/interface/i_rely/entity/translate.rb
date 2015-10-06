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
            contacts: nil,
            locations: nil,
            customer: nil
          )
            .merge!(id(payload))
        end
      end
    end
  end
end
