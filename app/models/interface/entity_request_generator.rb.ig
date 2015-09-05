module Interface
  # Build an interface request using an +Entity+ and the +StateManager+.
  # TODO: Make this east ward.
  class EntityRequestGenerator
    def initialize(entity, state_manager)
      @entity = entity
      @state_manager = state_manager
    end

    def call
      entity_hash
        .merge(contacts: contacts_hash)
        .merge(locations: locations_hash)
        .merge(customer: customer_hash)
    end

    protected

    def entity_hash
      state = state_manager.find(entity)
      {
        id: entity.id,
        name: entity.name,
        entity_type: entity.entity_type,
        interface_id: state.try(:interface_id)
      }
    end

    def state_manager
      @state_manager
    end

    def entity
      @entity
    end

    def contacts_hash
      entity.contacts.map do |contact|
        contact_hash(contact)
      end
    end

    def contact_hash(contact)
      state = state_manager.find(contact)
      {
        id: contact.id,
        name: contact.full_name,
        phone_number: contact.phone_number,
        fax_number: contact.fax_number,
        mobile_number: contact.mobile_number,
        email_address: contact.email_address,
        interface_id: state.try(:interface_id)
      }
    end

    def customer_hash
      state = state_manager.find(entity.customer)
      {
        id: entity.customer.id,
        interface_id: state.try(:interface_id),
        entity_type: entity.entity_type,
        credit_limit: 0
      }
    end

    def locations_hash
      entity.locations.map do |location|
        location_hash(location)
      end
    end

    def location_hash(location)
      state = state_manager.find(location)
      {
        id: location.id,
        name: location.location_name,
        street_address: location.street_address,
        city: location.city,
        region: location.region,
        region_code: location.region_code,
        country: location.country,
        phone_number: location.phone_number,
        fax_number: location.fax_number,
        interface_id: state.try(:interface_id)
      }
    end
  end
end
