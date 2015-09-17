module Interface
  module Entity
    class Upsert
      def initialize(entity, organization, request = nil)
        @context = Interface::ObjectContext.new(entity, organization)
        @request = request || build_request
        # @coherance = Interface::Coherance(entity, organization)
      end

      def call
        @request.call

        persist!
      end

      protected

      def build_request
        EntityRequest.new(context)
      end

      def persist!
        @context.object.save!
      end
    end
  end
end
