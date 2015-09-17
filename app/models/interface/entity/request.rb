module Interface
  module Entity
    class Request
      def initialize(context, interface = nil)
        @context = context
        # Should we be building the interface here or in the Upsert
        # where we need to decide which action we should take?
        @interface = interface || build_interface
      end

      def call
        @interface.call(payload)
      end

      protected

      def build_interface
        Interface::InterfaceFactory.build(@context)
      end

      def payload
        @payload ||= build_payload
      end

      def build_payload
        Payloads::EntityPayload.build_one(@context)
      end
    end
  end
end
