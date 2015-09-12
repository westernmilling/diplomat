module Interface
  class UpsertEntity
    # NB: Do we pass in a form of Logger class? Interface::Logger?
    def initialize(entity, organization)
      @entity = entity
      @organization = organization
      @context = Interface::StateContext.new(entity, organization)
      # @state_collection = state_collection
    end

    def call
      # TODO: determine action, insert or update?

      EntityRequest
        .new(@context, interface_class)
        .call

      # result?
      # Persist state information.
    end

    protected

    # NB: We could make this a lookup class
    def interface_class
      # TODO: Work this logic out
      Interface::IRely::AddEntity.new(@organization.integration)
    end
  end

  # At some point we may need the EntityUpsert to also insert other models
  # with the vendor API... i.e. iRely may also create/update company
  # locations (multiple levels, upsert, ins|upd, irely agg, irely calls)
end
