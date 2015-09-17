module Interface
  module Payloads
    ContactPayload = Struct.new(:id,
                                :full_name,
                                :email_address,
                                :fax_number,
                                :mobile_number,
                                :phone_number,
                                :uuid,
                                :interface_id) do
      extend Interface::Payload
    end
  end
end
