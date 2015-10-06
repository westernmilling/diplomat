module Interface
  class ObjectContext < Struct.new(:object, :organization)
    def object_map
      @object_map ||= object
        .interface_object_maps
        .select { |x| x.organization == organization }
        .first
    end
    # def adhesive
    #   @adhesive ||= Adhesive.find_by(interfaceable: object,
    #                                  organization: organization)
    # end
  end
end
