Promiscuous.define do
  subscribe :vendor do
    attributes :entity_id,
               :contact_id,
               :location_id,
               :deleted_at,
               :is_active,
               :uuid
  end
end
