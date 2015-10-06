module Interface
  module IRely
    module Translators
      class LocationTranslator < Translator
        class << self
          def translate(payload)
            return nil if payload.nil?

            payload = [payload] unless payload.is_a?(Array)

            payload.map { |x| translate_one(x) }
          end

          def translate_one(payload)
            translate_payload(payload)
              .merge(id(payload))
              .merge(row_state(payload))
          end

          def translate_payload(payload)
            {
              name: payload.location_name,
              address: payload.street_address,
              city: payload.city,
              state: payload.region,
              zipcode: payload.region_code,
              country: payload.country,
              termsId: 'Due on Receipt',
            }
          end
        end
      end
    end
  end
end
