module Interface
  module Payloads
    CustomerPayload = Struct.new(:id,
                                 :uuid,
                                 :interface_id) do
      extend Interface::Payload
    end
  end
end
