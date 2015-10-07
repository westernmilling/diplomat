module Interface
  module IRely
    module Customer
      class Translate < Interface::IRely::Translate
        def call
          translate(@object) unless @object.nil?

          self
        end

        def translate(object)
          @output.merge!(
            creditLimit: 0,
            type: object.entity.entity_type.capitalize
          )
        end

        def self.translate(object)
          return nil if object.nil?

          fail 'Single customer object expected' if object.is_a?(Array)

          new(object).call.output
        end
      end
    end
  end
end
