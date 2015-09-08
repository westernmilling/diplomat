module Interface
  # class EntityRequest < OpenStruct
  # end
  #
  # class ContactRequest < OpenStruct
  # end

  class EntityRequestFactory
    def initialize(entity, state_manager)
      @entity = entity
      @state_manager = state_manager
    end

    def build
      entity_hash
        .merge(contacts: contacts_hash)
        .merge(locations: locations_hash)
        .merge(customer: customer_hash)
    end

    def entity_hash
      state = state_manager.find(entity)
      {
        name: entity.name,
        entity_type: entity.entity_type
      }.merge(id_hash(state, entity))
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
        name: contact.full_name,
        phone_number: contact.phone_number,
        fax_number: contact.fax_number,
        mobile_number: contact.mobile_number,
        email_address: contact.email_address,
      }.merge(id_hash(state, contact))
    end

    def id_hash(state, object)
      if state
        { interface_id: state.interface_id }
      else
        { id: object.id }
      end
    end

    def customer_hash
      state = state_manager.find(entity.customer)
      {
        entity_type: entity.entity_type,
        credit_limit: 0
      }.merge(id_hash(state, entity.customer))
    end

    def locations_hash
      entity.locations.map do |location|
        location_hash(location)
      end
    end

    def location_hash(location)
      state = state_manager.find(location)
      {
        name: location.location_name,
        street_address: location.street_address,
        city: location.city,
        region: location.region,
        region_code: location.region_code,
        country: location.country,
        phone_number: location.phone_number,
        fax_number: location.fax_number
      }.merge(id_hash(state, location))
    end
  end
end
