Promiscuous.define do
  subscribe :salesperson do
    attributes :entity_id,
               :uuid,
               :default_location_id,
               :gender,
               :phone,
               :reference,
               :is_active
  end
end
