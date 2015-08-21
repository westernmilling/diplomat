FactoryGirl.define do
  factory :salesperson do
    uuid { UUID.generate(:compact) }
  end
end
