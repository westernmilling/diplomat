module Interface
  class LocationPayload < Struct.new(:id, :interface_id)

    def self.build_one(location, state_collection)
      new(id: location.id,
          location_name: location.full_name,
          street_address: location.street_address,
          city: location.city,
          region: location.region,
          region_code: location.region_code,
          country: location.country,
          phone_number: location.phone_number,
          fax_number: location.fax_number)
    end
  end
end
