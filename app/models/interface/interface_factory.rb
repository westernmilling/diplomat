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
      !new? && @context.adhesive.version > @context.object._v
    end

    def interface_class
      [
        @context.organization.integration.interface_namespace,
        @context.object.class.name,
        action.to_s
      ].join('::').constantize
    end

    def action
      new? ? :Insert : :Update
    end

    def new?
      @context.adhesive.nil?
    end
  end
end
