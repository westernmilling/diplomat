module Interface
  module Entity
    class Upsert
      def initialize(entity, organization)
        @context = build_context(entity, organization)
        @interface = build_interface
      end

      def call
        @interface.call

        persist!
      end

      protected

      def build_interface
        Interface::InterfaceFactory.build(@context)
      end

      def build_context(entity, organization)
        Interface::ObjectContext.new(entity, organization)
      end

      def persist!
        @context.object.save!
      end
    end
  end
end
