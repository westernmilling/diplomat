module Interface
  module Payloads
    EntityPayload = Struct.new(:id,
                               :interface_id,
                               :name,
                               :reference,
                               :uuid) do
      extend Payload

      # Create a new instance of an +EntityPayload+
      def initialize
        @contacts = []
        @locations = []
        @customer = nil
      end

      def self.build_one(context)
        super(context)
          .add_contacts(context)
          .add_locations(context)
          .add_traits(context)
      end

      def contacts
        @contacts
      end

      def locations
        @locations
      end

      def customer
        @customer
      end

      # NB: This smells, how can we clean this up... however its pretty low
      #     impact at the moment.

      def add_contacts(context)
        contacts_context = context.object.contacts.map do |contact|
          context.dup.tap { |x| x.object = contact }
        end
        @contacts = ContactPayload.build(contacts_context)

        self
      end

      def add_locations(context)
        locations_context = context.object.locations.map do |location|
          context.dup.tap { |x| x.object = location }
        end
        @locations = LocationPayload.build(locations_context)

        self
      end

      def add_traits(context)
        context.dup.tap { |x| x.object = context.object.customer }

        @customer = CustomerPayload.build(context)

        self
      end
    end
  end
end
