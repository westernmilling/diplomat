module Interface
  module Payloads
    CustomerPayload = Struct.new(:id,
                                 :credit_limit,
                                 :customer_type,
                                 :uuid,
                                 :interface_id) do
      extend Interface::Payload
    end
  end
end
