module Interface
  module Payloads
    LocationPayload = Struct.new(:id,
                                 :location_name,
                                 :street_address,
                                 :city,
                                 :region,
                                 :region_code,
                                 :country,
                                 :fax_number,
                                 :phone_number,
                                 :uuid,
                                 :interface_id) do
      extend Interface::Payload
    end
  end
end
