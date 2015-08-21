Promiscuous.define do
  subscribe :salesperson do
    attributes :entity_id,
               :gender,
               :is_active,
               :deleted_at,
               :uuid
  end
end
