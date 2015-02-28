Promiscuous.define do
  subscribe :entity do
    attributes :cached_long_name,
               :comments,
               :display_name, :is_active, :name, :reference, :uuid
  end
end
