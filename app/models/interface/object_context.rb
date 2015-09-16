module Interface
  # class AdhesiveContext < Struct.new(:object, :organization)
  class ObjectContext < Struct.new(:object, :organization)
    def adhesive
      @adhesive ||= Adhesive.find_by(interfaceable: object,
                                     organization: organization)
    end
  end
  # class Coherance < Struct.new(:object, :organization)
  # end
end
