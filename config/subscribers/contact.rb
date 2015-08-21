Promiscuous.define do
  subscribe :contact do
    attributes :entity_id,
               :full_name,
               :title,
               :email_address,
               :fax_number,
               :mobile_number,
               :phone_number,
               :deleted_at,
               :is_active,
               :uuid
  end
end
