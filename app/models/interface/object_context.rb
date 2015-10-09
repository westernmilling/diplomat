module Interface
  # Wrap an object and its associations in an +Organization+ based context.
  ObjectContext = Struct.new(:child_contexts,
                             :graph,
                             :organization,
                             :root_instance) do
    def initialize(object, organization, graph = {})
      self.child_contexts = {}
      self.root_instance = object
      self.organization = organization
      self.graph = graph
      self.graph.each do |k, v|
        self.child_contexts[k] = build(object.send(k), v)
      end if self.graph
    end

    def build(item, graph)
      if item.respond_to?(:each)
        item.map { |x| build_one(x, graph) }
      else
        build_one(item, graph)
      end
    end

    def build_one(item, graph)
      Interface::ObjectContext
        .new(item, self.organization, graph)
    end

    def object_map
      @object_map ||= root_instance
        .interface_object_maps
        .select { |x| x.organization == organization }
        .first
    end
  end
end
