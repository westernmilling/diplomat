module Interface
  module IRely
    # Translate the context to a vendor api compliant data structure.
    class Translate
      def initialize(context, output = {})
        @context = context
        @output = output
      end

      def call
        fail 'You may not call the base Translate class'
      end

      def output
        @output
      end

      def self.translate(context)
        return nil if context.nil?

        context = [context] unless context.is_a?(Array)

        context.map { |x| new(x).call.output }
      end

      protected

      def id
        return { id: @context.root_instance.id } if @context.object_map.nil?

        { id: @context.object_map.id, i21_id: @context.object_map.interface_id }
      end

      def row_state
        return { rowState: 'Added' } if @context.object_map.nil?

        { rowState: 'Modified' }
      end
    end
  end
end
