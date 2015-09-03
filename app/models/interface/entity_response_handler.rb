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
      add_or_update_state(@entity, response[:interface_id])

      add_or_update_state(
        @entity.customer,
        response[:customer][:interface_id]) if response[:customer].present?

      response[:contacts].each do |contact_resp|
        contact = @entity.contacts.detect { |x| x.id == contact_resp[:id] }

        add_or_update_state(contact, contact_resp[:interface_id])
      end

      response[:locations].each do |location_resp|
        location = @entity.locations.detect { |x| x.id == location_resp[:id] }

        add_or_update_state(location, location_resp[:interface_id])
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
  end
end
