Promiscuous.define do
  subscribe :contact do
    attributes :entity_id,
               :first_name,
               :last_name,
               :display_name,
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
