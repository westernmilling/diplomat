module Interface
  module Payload
    # Sort out class and instance methods, we want to support both
    # class << self
      def build(context)
        if context.is_a?(Array)
          context.each { |x| build_one(x) }
        else
          [build_one(context)]
        end
      end

      def build_one(context)
        # Abc = 13?
        new.merge!(context.object.attributes).tap do |payload|
          payload.interface_id = context.state.interface_id \
            if context.state.present?
        end
      end
    # end
  end
end
