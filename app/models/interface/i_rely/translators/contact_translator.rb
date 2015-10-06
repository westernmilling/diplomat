module Interface
  module IRely
    module Translators
      class ContactTranslator < Translator
        def self.translate(payload)
          return nil if payload.nil?

          payload = [payload] unless payload.is_a?(Array)
          payload.map { |x| translate_one(x) }
        end

        def self.translate_one(payload)
          {
            name: payload.full_name,
            phone: payload.phone_number,
            fax: payload.fax_number,
            mobile: payload.mobile_number,
            email: payload.email_address,
          }
            .merge(id(payload))
            .merge(row_state(payload))
        end
      end
    end
  end
end
