module Interface
  # class AdhesiveContext < Struct.new(:object, :organization)
  class ObjectContext < Struct.new(:object, :organization)
    def adhesive
      @adhesive ||= object
        .interface_adhesives
        .select { |x| x.organization == organization }
        .first
    end
    # def adhesive
    #   @adhesive ||= Adhesive.find_by(interfaceable: object,
    #                                  organization: organization)
    # end
  end
  # class Coherance < Struct.new(:object, :organization)
  # end
end
