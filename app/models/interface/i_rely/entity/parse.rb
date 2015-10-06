module Interface
  module IRely
    module Entity
      class Parse < Interface::IRely::Parse
        def call
          return self if no_data?

          parse

          self
        end

        def no_data?
          @response.nil? || @response[:data].nil? || @response[:data].empty?
        end

        def parse
          parse_entity
          parse_contacts
          parse_locations
          # parse_customer
        end

        def parse_entity
          @payload.interface_id = entity_response[:i21_id]
        end

        def parse_contacts
          @payload.contacts.each_with_index do |contact_payload, index|
            Interface::IRely::Contact::Parse
              .new(contact_payload,
                   entity_response[:contacts][index])
              .call
          end
        end

        def parse_locations
          @payload.locations.each_with_index do |location_payload, index|
            Interface::IRely::Location::Parse
              .new(location_payload,
                   entity_response[:locations][index])
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

        def entity_response
          @entity_response ||= @response[:data][0]
        end
      end
    end
  end
end
