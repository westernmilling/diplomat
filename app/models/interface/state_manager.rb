module Interface
  class StateManager
    attr_reader :all_states

    # TODO: Test filtering by organization and interfaceable

    def initialize(organization, states = [])
      @organization = organization
      @all_states = states
    end

    def add_state(interfaceable, interface_id)
      state = Interface::State.new
      state.interface_id = interface_id
      state.interfaceable = interfaceable
      state.integration = @organization.integration
      state.organization = @organization
      state.version = interfaceable._v
      @all_states << state

      state
    end
    alias :add :add_state

    def exist?(interfaceable)
      find_state(interfaceable).present?
    end

    def find_state(interfaceable)
      find_states(interfaceable).first
    end
    alias :find :find_state

    def find_by_interface_id(type, interface_id)
      @all_states.detect do |x|
        x.interfaceable_type == type.to_s && \
          x.interface_id == interface_id.to_s && \
          x.integration == @organization.integration
      end
    end

    def find_states(interfaceable)
      @all_states.select do |x|
        x.interfaceable == interfaceable && \
          x.integration == @organization.integration && \
          x.organization == @organization
      end
    end

    def persist!
      @all_states.each &:save!
    end

    def states(interfaceable)
      find_states(interfaceable)
    end

    def update_version(interfaceable)
      state = find_state(interfaceable)
      state.version = interfaceable._v
      self
    end
  end
end
