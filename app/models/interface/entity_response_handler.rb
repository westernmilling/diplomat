module Interface
  # Updates interface state in a +Interface::StataManager+ using information
  # from an Entity interface response.
  class EntityResponseHandler
    def initialize(entity, state_manager)
      @entity = entity
      @state_manager = state_manager
    end

    # Updates state from the response information
    # @param [Hash] entity response information
    def call(response)
      # NB: This is horrible, clean!
      add_or_update_state(@entity, response[:interface_id])

      add_or_update_state(
        @entity.customer,
        response[:customer][:interface_id]) if response[:customer].present?

      if response[:contacts]
        response[:contacts].each do |contact_resp|
          if contact_resp[:id]
            contact = @entity.contacts.detect do |x|
              x.id == contact_resp[:id].to_i
            end
          else
            contact = find_state_by_interfaceable(
              Contact, contact_resp[:interface_id])
          end

          add_or_update_state(contact, contact_resp[:interface_id])
        end
      end

      if response[:locations]
        response[:locations].each do |location_resp|
          if location_resp[:id]
            location = @entity.locations.detect do |x|
              x.id == location_resp[:id].to_i
            end
          else
            location = find_state_by_interfaceable(
              Location, location_resp[:interface_id])
          end

          add_or_update_state(location, location_resp[:interface_id])
        end
      end
    end

    protected

    def add_or_update_state(interfaceable, interface_id)
      if @state_manager.exist?(interfaceable)
        @state_manager.update_version(interfaceable)
      else
        @state_manager.add(interfaceable, interface_id)
      end
    end

    def find_state_by_interfaceable(type, interface_id)
      state = @state_manager.find_by_interface_id(type, interface_id)

      return state.interfaceable if state.present?
    end
  end
end
