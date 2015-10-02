module Interface
  module IRely
    module Translators
      class Translator
        def self.id(payload)
          return { i21_id: payload.interface_id } if payload.interface_id.present?

          { id: payload.id }
        end

        def self.row_state(payload)
          { rowState: payload.interface_id.present? ? 'Updated' : 'Added' }
        end
      end
    end
  end
end
