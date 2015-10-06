module Interface
  module IRely
    module Translators
      class CustomerTranslator < Translator
        def self.translate(payload)
          return nil if payload.nil?

          fail 'Single customer payload expected' if payload.is_a?(Array)

          translate_one(payload)
        end

        def self.translate_one(payload)
          {
            type: payload.customer_type.humanize,
            creditLimit: payload.credit_limit,
          }
            # .merge(id(payload))
            # .merge(row_state(payload))
        end
      end
    end
  end
end
