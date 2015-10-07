module Interface
  class Result < Struct.new(:status, :response)
  end
  module Entity
    class Request
      def initialize(context, interface = nil)
        @context = context
        # Should we be building the interface here or in the Upsert
        # where we need to decide which action we should take?
        @interface = interface || build_interface
      end

      def call
        # V1: We're doing some asking here
        # result = @interface.call(payload)

        # TODO: Use the native result to create a log entry.
        #       How do we get the native result back?
        # TODO: Now we need to build the mappings from the payload
        # Entity::Map.new(@context.object, payload).call

        # V2: Try not to ask anything... push it all down
        #     The interface will convert to payload, merge results back, and log
        @interface.call(@context)
      end

      protected

      def build_interface
        Interface::InterfaceFactory.build(@context)
      end

      # def payload
      #   @payload ||= build_payload
      # end
      #
      # def build_payload
      #   Payloads::EntityPayload.build_one(@context)
      # end
    end

    # TODO: Proof of concept?
    class Map
      def initialize(interfaceable, payload)
        @interfaceable = interfaceable
        @payload = payload
      end

      def call

      end
    end
  end
end
