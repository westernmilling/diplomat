module Interface
  # consider inherting from an Array or Enumerable?
  class OrganizationStateCollection
    # TODO: Evaluate why we need access to the states here?
    attr_reader :states

    # TODO: Test filtering by organization and interfaceable

    def initialize(organization, states = [])
      @organization = organization
      @states = states
    end

    def add(interfaceable, interface_id)
      state = Interface::State.new
      state.interface_id = interface_id
      state.interfaceable = interfaceable
      state.integration = @organization.integration
      state.organization = @organization
      state.version = interfaceable._v
      @states << state

      state
    end

    def exist?(interfaceable)
      find(interfaceable).present?
    end

    def find(interfaceable)
      find_many(interfaceable).first
    end

    # def find_by_interface_id(type, interface_id)
    #   @states.detect do |x|
    #     x.interfaceable_type == type.to_s && \
    #       x.interface_id == interface_id.to_s && \
    #       x.integration == @organization.integration
    #   end
    # end

    def find_many(interfaceable)
      @states.select do |x|
        x.interfaceable == interfaceable && \
          x.integration == @organization.integration && \
          x.organization == @organization
      end
    end

    def persist!
      @states.each &:save!
    end

    def update_version(interfaceable)
      state = find(interfaceable)
      state.version = interfaceable._v
      self
    end
  end
end
