module Interface
  class InterfaceFactory
    class << self
      def build(context)
        new(context).build
      end
    end

    def initialize(context)
      @context = context
    end

    def build
      return IgnoreOldVersion.new(@context) if old?

      interface_class.new(@context)
    end

    def old?
      !new? && @context.object_map.version > @context.root_instance._v
    end

    def interface_class
      [
        @context.organization.integration.interface_namespace,
        @context.root_instance.class.name,
        action.to_s
      ].join('::').constantize
    end

    def action
      new? ? :Insert : :Update
    end

    def new?
      @context.object_map.nil?
    end
  end
end
