Promiscuous.define do
  subscribe :organization do
    attributes :is_active,
               :name,
               :uuid
  end
end
