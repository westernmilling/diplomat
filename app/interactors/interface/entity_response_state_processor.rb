module Interface
  class EntityResponseStateProcessor
    include Interactor

    delegate :entity, to: :context
    delegate :response, to: :context
    delegate :state_manager, to: :context

    def call
      process_entity_response response
      process_contact_response response[:contacts]
      process_location_response response[:locations]
    end

    def process_entity_response(entity_response)
      state = find_state(entity)

      update_state(entity,
                   state.count + 1,
                   entity_response[:interface_id],
                   :success,
                   entity._v)
    end

    def process_contact_response(contacts_response)
      contacts_response.each do |response|
        contact = entity.contacts.detect { |x| x.id == response[:id] }

        state = find_state(contact)

        update_state(contact,
                     state.count + 1,
                     response[:interface_id],
                     :success,
                     contact._v)
      end
    end

    def process_location_response(locations_response)
      locations_response.each do |response|
        location = entity.locations.detect { |x| x.id == response[:id] }
        state = find_state(location)
        update_state(location,
                     state.count + 1,
                     response[:interface_id],
                     :success,
                     location._v)
      end
    end

    def find_state(interfaceable)
      state_manager.find_or_add_state(interfaceable)
    end

    def update_state(interfaceable, count, interface_id, status, version)
      state_manager.update(interfaceable,
                            'action',
                            count,
                            interface_id,
                            status,
                            version)
    end
  end
end
