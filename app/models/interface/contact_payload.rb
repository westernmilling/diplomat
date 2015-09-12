module Interface
  class ContactPayload < OpenStruct
  # class ContactPayload < Struct.new(:id,
  #                                   :full_name,
  #                                   :interface_id)
    extend Interface::Payload
    # def self.build_one(contact, state_collection)
    #   # new(id: contact.id,
    #   #     full_name: contact.full_name,
    #   #     phone_number: contact.phone_number,
    #   #     fax_number: contact.fax_number,
    #   #     mobile_number: contact.mobile_number)
    #   new.merge!(contact)
    #   # Add in the interface id from the state
    # end
    # def self.build_one(context)
    #   # We can probably refactor this into a single method
    #   super(context).tap do |payload|
    #     state = context
    #             .object
    #             .interface_states
    #             .select do |x|
    #               x.interfaceable == context.object &&
    #               x.organization == context.organization
    #             end.first
    #
    #     payload.interface_id = state.interface_id if state.present?
    #   end
    # end
  end
end
