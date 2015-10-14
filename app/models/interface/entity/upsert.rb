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
        Interface::ObjectContext.new(entity, organization, object_graph)
      end

      def object_graph
        { contacts: nil, locations: nil, customer: nil }
      end

      def persist!
        @context.root_instance.save!
      end
    end
  end
end
