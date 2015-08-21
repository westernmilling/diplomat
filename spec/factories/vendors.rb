FactoryGirl.define do
  factory :vendor do
    is_active 1
    uuid { UUID.generate(:compact) }
  end
end
