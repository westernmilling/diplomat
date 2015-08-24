Promiscuous.define do
  subscribe :organization_entity do
    attributes :entity_id,
               :organization_id,
               :trait,
               :deleted_at,
               :uuid
  end
end
