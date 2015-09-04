class Interface::EntityRequestGenerator
  include Interactor

  delegate :entity, to: :context
  delegate :state_manager, to: :context

  # What about something to build the request,
  # and something else to decorate the request
  # with the interface id's from state?
  def call
    context.request = entity_hash
                      .merge(contacts: contacts_hash)
                      .merge(locations: locations_hash)
  end

  protected

  def entity_hash
    state = state_manager.find(entity)
    {
      name: entity.name,
      interface_id: state.try(:interface_id)
    }
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
      interface_id: state.try(:interface_id)
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
