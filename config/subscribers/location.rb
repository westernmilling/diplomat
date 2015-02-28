Promiscuous.define do
  subscribe :location do
    attributes :entity_id,
               :location_name,
               :street_address,
               :city,
               :region,
               :region_code,
               :country,
               :latitude,
               :longitude,
               :is_active,
               :uuid
  end
end
