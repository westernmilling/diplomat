FactoryGirl.define do
  factory :organization do
    name Faker::Company.name
    uuid { UUID.generate(:compact) }
  end
end
