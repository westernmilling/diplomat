Promiscuous.define do
  subscribe :customer do
    attributes :entity_id,
               :contact_id,
               :location_id,
               :parent_customer_id,
               :salesperson_id,
               :deleted_at,
               :bill_to_location_id,
               :ship_to_location_id,
               :is_tax_excempt,
               :is_active,
               :uuid
  end
end
