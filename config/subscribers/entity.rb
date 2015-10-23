Promiscuous.define do
  subscribe :entity do
    attributes :cached_long_name,
               :comments,
               :contact_id,
               :deleted_at,
               :display_name,
               :entity_type,
               :federal_tax_id,
               :is_active,
               :is_withholding,
               :name,
               :parent_entity_id,
               :reference,
               :tax_number,
               :tax_state,
               :ten99_form,
               :ten99_type,
               :ten99_print,
               :ten99_signed_at,
               :uuid
  end
end
