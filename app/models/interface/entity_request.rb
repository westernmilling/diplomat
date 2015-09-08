module Interface
  # A request to perform +Entity+ related functions using a desired interface.
  #   An east oriented approach.
  #
  # The +EntityRequest+ accepts an instance of an +Entity+ along with various
  # state about this entity and uses them to build an +EntityPayload+ instance
  # used when calling the provided interface.
  #
  # => EntityUpsert notes...
  # The +EntityUpsert+ will invoke a new instance of the +EntityRequest+ with
  # an appropriate interface object depending on the current state of the
  # Entity (new or existing).
  #
  # EntityUpsert
  #  - Get entity state for the organization being processed
  #    * Or did this happen before and the upsert has a state collection?
  #  - Determine interface to use
  #  - Create and call EntityRequest using the interface
  #
  class EntityRequest
    # @param [Entity] The entity having actions performed upon.
    # @param [OrganizationStateCollection] A collection of +Interface::State+
    #        instances for a single +Organization+.
    # @param [Object] The interface object, this could be a wrapper for an
    #        interface to an external vendors API.
    def initialize(entity, state_collection, interface)
      @entity = entity
      @state_collection = state_collection
      @interface = interface
    end

    # Invoke the request
    def call
      @interface.call(payload)
    end

    private

    def payload
      @payload ||= build_payload
    end

    # Builds an +EntityPayload+ from the +Entity+ instance and existing state
    # stored in a state collection.
    def build_payload
      EntityPayload.build(@entity, @state_collection)
    end
  end

  class EntityPayload < Struct.new(:id, :interface_id, :name, :reference)
    def initialize(entity) #, state_manager)
      @contacts = []
      @locations = []
      @customer = nil
      # build the new instance using the entity and state_manager
      # merge the basics of the Entity with this payload
      # add the interface id from the state_manager
    end

    def self.build(entity, state_collection)
      # Abc = 13?
      state = state_collection.find(entity)

      # new(entity, state_collection)
      new(entity) do |payload|
        payload.interface_id = state.interface_id
      end

      payload.add_contacts(entity, state_collection)
      payload.add_locations(entity, state_collection)
      payload.add_traits(entity, state_collection)
      # payload.contacts = ContactPayload.build(entity.contacts, state_manager)
    end

    protected

    def add_contacts(entity, state_collection)
      @contacts = ContactPayload.build(entity.contacts, state_collection)
    end

    def add_locations(entity, state_collection)
      @locations = LocationPayload.build(entity.locations, state_collection)
    end

    def add_traits(entity, state_collection)
      @customer = CustomerPayload.build(entity.customer, state_collection)
    end
  end

  class ContactPayload < Struct.new(:id, :interface_id)
    def initialize(contact)
    end

    def self.build(source, state_collection)
      if source.is_a?(Array)
        source.each { |x| build_one(x, state_collection) }
      else
        [build_one(contact, state_collection)]
      end
    end

    def self.build_one(contact, state_collection)
      # build one contact
    end
  end

  class LocationPayload < Struct.new(:id, :interface_id)
  end

  class CustomerPayload < Struct.new(:id, :interface_id)
  end
end
