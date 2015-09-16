module Interface
  module Entity
    class Request
      def initialize(context)
        @context = context
      end

      def call
        interface.call(payload)
      end

      def interface
        Interface::IntegrationFactory.build(@context).call
      end

      def payload
        @payload ||= build_payload
      end

      def build_payload
        nil
      end
    end
  end
end
