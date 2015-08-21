Promiscuous.define do
  subscribe :location do
    attributes :entity_id,
               :location_name,
               :street_address,
               :city,
               :region,
               :region_code,
               :country,
               :phone_number,
               :fax_number,
               :latitude,
               :longitude,
               :cached_long_address,
               :deleted_at,
               :is_active,
               :uuid
  end
end
