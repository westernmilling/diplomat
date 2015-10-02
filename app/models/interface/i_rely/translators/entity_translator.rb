module Interface
  module IRely
    module Translators
      class EntityTranslator < Translator
        def self.translate(payload)
          if payload.is_a?(Array)
            payload.map { |x| translate_one(x) }
          else
            [translate_one(payload)]
          end
        end

        def self.translate_one(payload)
          {
            name: payload.name,
            contacts: ContactTranslator.translate(payload.contacts),
            locations: LocationTranslator.translate(payload.locations),
            customer: CustomerTranslator.translate(payload.customer)
          }
            .merge(id(payload))
        end
      end
    end
  end
end
