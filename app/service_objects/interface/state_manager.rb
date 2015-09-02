module Interface
  class StateManager
    attr_reader :all_states

    # TODO: Test filtering by organization and interfaceable

    def initialize(organization, states = [])
      @organization = organization
      @all_states = states
    end

    def add_state(interfaceable)
      state = Interface::State.new
      state.count = 0
      state.interfaceable = interfaceable
      state.integration = @organization.integration
      state.organization = @organization
      @all_states << state

      state
    end

    def find_state(interfaceable)
      find_states(interfaceable).first
    end

    def find_states(interfaceable)
      @all_states.select do |x|
        x.interfaceable == interfaceable && \
        x.integration == @organization.integration && \
        x.organization == @organization
      end
    end

    def find_or_add_state(interfaceable)
      state = find_state(interfaceable)

      return state if state.present?

      add_state(interfaceable)
    end

    def persist!
      @all_states.each { |x| x.save! }
    end

    def states(interfaceable)
      find_states(interfaceable)
    end

    def update(interfaceable, action, count, interface_id, status, version)
      state = find_state(interfaceable)
      # state.action = action.downcase.to_sym
      state.count = count
      state.interface_identifier = interface_id
      state.status = status
      state.version = version

      self
    end
  end
end
