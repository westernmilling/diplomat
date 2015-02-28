Promiscuous.define do
  subscribe :vendor do
    attributes :entity_id,
               :uuid,
               :default_contact_id,
               :default_location_id,
               :reference,
               :is_active
  end
end
