Promiscuous.define do
  subscribe :entity do
    attributes :cached_long_name,
               :comments,
               :display_name, :is_active, :name, :reference, :uuid
  end

  subscribe :location do
    attributes :entity_id,
               :location_name,
               :street_address,
               :city,
               :region,
               :region_code,
               :country,
               :latitude,
               :longitude,
               :is_active,
               :uuid
  end

  subscribe :contact do
    attributes :uuid,
               :first_name,
               :last_name,
               :display_name,
               :title,
               :email_address,
               :fax_number,
               :mobile_number,
               :phone_number,
               :is_active
  end
end
