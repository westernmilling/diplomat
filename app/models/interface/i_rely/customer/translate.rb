module Interface
  module IRely
    module Customer
      class Translate < Interface::IRely::Translate
        def call
          translate(@payload) unless @payload.nil?

          self
        end

        def translate(payload)
          @output.merge!(
            creditLimit: 0,
            type: payload.customer_type.capitalize
          )
        end

        def self.translate(payload)
          return nil if payload.nil?

          fail 'Single customer payload expected' if payload.is_a?(Array)

          new(payload).call.output
        end
      end
    end
  end
end
