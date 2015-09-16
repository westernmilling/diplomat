# module Interface
#   module Entity
#     class Upsert
#       def initialize(entity, organization)
#         @context = Interface::ObjectContext.new(entity, organization)
#         # @coherance = Interface::Coherance(entity, organization)
#       end
#
#       def call
#         Interface::InterfaceFactory.build(@context).call
#
#         # TODO: Do we persist the entity and children here?
#       end
#     end
#   end
# end
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

        # persist!
      end

      protected

      def build_request
        EntityRequest.new(context)
      end

      # def request
      #   EntityRequest.new(context)
      # end

      # def persist!
      #   @context.entity.save!
      # end
    end
  end
end
