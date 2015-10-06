module Interface
  module IRely
    class Translate
      def initialize(payload, output = {})
        @payload = payload
        @output = output
      end

      def call
        fail 'You may not call the base Translate class'
      end

      def output
        @output
      end

      def self.translate(payload)
        return nil if payload.nil?

        payload = [payload] unless payload.is_a?(Array)

        payload.map { |x| new(x).call.output }
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
