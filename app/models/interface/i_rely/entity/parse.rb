module Interface
  module IRely
    module Entity
      class Parse < Interface::IRely::Parse
        def call
          parse unless no_data?

          self
        end

        def no_data?
          @response.nil? || @response[:data].nil? || @response[:data].empty?
        end

        def parse
          parse_entity
          parse_contacts
          parse_locations
        end

        def parse_entity
          build_map if @context.object_map.nil?

          @context.object_map.interface_id = item_response[:i21_id]
          @context.object_map.version = @context.root_instance._v
        end

        def parse_contacts
          @context
            .child_contexts[:contacts]
            .each_with_index do |child_context, index|
            Interface::IRely::Contact::Parse
              .new(child_context, item_response[:contacts][index])
              .call
          end
        end

        def parse_locations
          @context
            .child_contexts[:locations]
            .each_with_index do |child_context, index|
            Interface::IRely::Location::Parse
              .new(child_context, item_response[:locations][index])
              .call
          end
        end

        # def parse_customer
        #   # TODO: Write a test for this condition before we implement it.
        #   #       Or do we leave the Parse class to deal with it?
        #   # return if entity_response[:customer].nil?
        #
        #   Interface::IRely::Customer::Parse
        #     .new(@payload.customer, entity_response[:customer])
        #     .call
        # end

        def item_response
          @item_response ||= @response[:data][0]
        end
      end
    end
  end
end
