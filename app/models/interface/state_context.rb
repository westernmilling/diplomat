module Interface
  class StateContext < Struct.new(:object, :organization)
    def state
      object
        .interface_states
        .select do |x|
          x.interfaceable == object &&
          x.organization == organization
        end.first
    end
  end
end
