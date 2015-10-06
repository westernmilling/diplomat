module Interface
  module IRely
    class Parse
      def initialize(payload, response = {})
        @payload = payload
        @response = response
      end

      def call
        fail 'You may not call the base Parse class'
      end

      def payload
        @payload
      end

      # def self.parse(payload, response)
      #   return nil if payload.nil?
      #
      #   payload = [payload] unless payload.is_a?(Array)
      #
      #   payload.map { |x| new(payload).call.output }
      # end

      protected

    end
  end
end
