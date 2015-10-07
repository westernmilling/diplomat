module Interface
  module IRely
    class Translate
      def initialize(object, output = {})
        @object = object
        @output = output
      end

      def call
        fail 'You may not call the base Translate class'
      end

      def output
        @output
      end

      def self.translate(object)
        return nil if object.nil?

        object = [object] unless object.is_a?(Array)

        object.map { |x| new(x).call.output }
      end

      protected

      def id(record)
        return { id: record.id } if record.interface_id.nil?

        { id: record.id, i21_id: record.interface_id }
      end

      def row_state(record)
        { rowState: record.interface_id.present? ? 'Modified' : 'Added' }
      end
    end
  end
end
