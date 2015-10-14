module Interface
  module IRely
    module Customer
      class Translate < Interface::IRely::Translate
        def call
          translate unless @context.nil?

          self
        end

        def translate
          @output.merge!(
            creditLimit: 0,
            # NB: This is a bit smelly, but what alternative is there?
            type: @context.root_instance.entity.entity_type.capitalize
            # intBillToId: 
          )
        end

        def self.translate(context)
          return nil if context.nil?

          fail 'Single customer object expected' if context.is_a?(Array)

          new(context).call.output
        end
      end
    end
  end
end
