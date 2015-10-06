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
        payload.interface_id = context.object_map.interface_id \
          if context.object_map.present?
      end
    end
  end
end
