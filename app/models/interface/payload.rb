module Interface
  module Payload
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
        payload.interface_id = context.adhesive.interface_id \
          if context.adhesive.present?
      end
    end
  end
end
