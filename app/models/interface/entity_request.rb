module Interface
  # A request to perform +Entity+ related functions using a desired interface.
  #   An east oriented approach.
  class EntityRequest
    # @param [Entity] The entity having actions performed upon.
    # @param [OrganizationStateCollection] A collection of +Interface::State+
    #        instances for a single +Organization+.
    # @param [Object] The interface object, this could be a wrapper for an
    #        interface to an external vendors API.
    # def initialize(entity, state_collection, interface)
    #   @entity = entity
    #   @state_collection = state_collection
    #   @interface = interface
    # end
    def initialize(context, interface)
      @context = context
      @interface = interface
    end

    def call
      # Use an InterfaceFactory.build(integration) called from the calling
      # class to new up this interface class.
      @interface.call(@context.organization.integration, payload)

      # Somewhere we need to extract information from the
      # payload into the Entity
    end

    private

    def payload
      @payload ||= build_payload
    end

    # Builds an +EntityPayload+ from the +Entity+ instance and existing state
    # stored in a state collection.
    def build_payload
      EntityPayload.build_one(@context)
    end
  end
end
