module Interface
  module Test
    # Do we model this as...
    # class EntityInsert
    # class CustomerInsert < EntityInsert
    # class VendorInsert < EntityInsert
    class EntityInsert
      include Interactor

      def call
      end
    end

    class EntityUpdate
      include Interactor

      def call
      end
    end
  end
end
