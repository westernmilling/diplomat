module Interface
  module IRely
    class Parse
      # TODO: Test the base class, create anon class in spec to inherit from it
      def initialize(context, response = {})
        @context = context
        @response = response
      end

      def call
        fail 'You may not call the base Parse class'
      end

      def no_data?
        @response.nil?
      end

      def parse
        build_map if @context.object_map.nil?

        @context.object_map.interface_id = @response[:i21_id]
        @context.object_map.version = @context.root_instance._v
      end

      def context
        @context
      end

      def build_map
        @context.root_instance.interface_object_maps <<
          Interface::ObjectMap.new(
            interfaceable: @context.root_instance,
            integration: @context.organization.integration,
            organization: @context.organization,
            version: @context.root_instance._v
          )
      end

      protected

    end
  end
end
