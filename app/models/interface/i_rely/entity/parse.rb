module Interface
  module IRely
    module Entity
      class Parse < Interface::IRely::Parse
        # TODO: Consider expanding this to use payload object specific
        #       parsers, i.e. Contact, Location, Customer, etc.
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
          # parse_locations
        end

        def parse_entity
          @payload.interface_id = entity_response[:i21_id]
          # @payload.locations.each do |location_payload|
          #   Interface::IRely::Location::Parse
          #     .new(location_payload, entity_response)
          #     .call
          # end
        end

        def parse_contacts
          @payload.contacts.each do |contact_payload|
            Interface::IRely::Contact::Parse
              .new(contact_payload, entity_response)
              .call
          end
        end

        def entity_response
          @response[:data][0]
        end

        # def self.parse(payload, response)
        #   new(payload, response).payload
        # end
      end
    end
  end
end
