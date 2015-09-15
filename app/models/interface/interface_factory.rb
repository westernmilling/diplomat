module Interface
  class InterfaceFactory
    class << self
      def build(context)
        new(context).factory
      end
    end

    def initialize(context)
      @context = context
    end

    def factory
      return IgnoreOldVersion.new(@context) if old_version?

      interface_class.new(@context)
    end

    protected

    def action
      new? ? :Insert : :Update
    end

    def adhesive
      @adhesive ||= Adhesive.find_by(interfaceable: @context.object,
                                     organization: @context.organization)
    end

    def interface_class
      [
        'Interface',
        @context.object.class.name,
        action.to_s
      ].join('::').constantize
    end

    def new?
      adhesive.nil?
    end

    def old_version?
      adhesive && adhesive.version > @context.object._v
    end
  end
end
