module Interface
  module IRely
    module Translators
      class CustomerTranslator < Translator
        def self.translate(payload)
          if payload.is_a?(Array)
            payload.map { |x| translate_one(x) }
          else
            [translate_one(payload)]
          end
        end

        def self.translate_one(payload)
          {
            type: payload.customer_type,
            creditLimit: payload.credit_limit,
          }
            .merge(id(payload))
            .merge(row_state(payload))
        end
      end
    end
  end
end
