module Interface
  # class EntityPayload < Struct.new(:id, :interface_id, :name, :reference)
  class EntityPayload < OpenStruct
    extend Payload

    # Create a new instance of an +EntityPayload+
    def initialize
      @contacts = []
      @locations = []
      @customer = nil
    end

    def self.build_one(context)
      super(context).tap do |payload|
        payload.add_contacts(context)
        payload.add_locations(context)
        payload.add_traits(context)
      end
    end

    protected

    def add_contacts(context)
      contacts_context = entity.contacts.map do |contact|
        context.dup.tap { |x| x.object = contact }
        # StateContext.new(object: contact, organization: context.organization)
      end
      # @contacts = ContactPayload.build(entity.contacts, state_collection)
      @contacts = ContactPayload.build(contacts_context)
    end

    def add_locations(entity, state_collection)
      # @locations = LocationPayload.build(entity.locations, state_collection)
    end

    def add_traits(entity, state_collection)
      # @customer = CustomerPayload.build(entity.customer, state_collection)
    end
  end
end
