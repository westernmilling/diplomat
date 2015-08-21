FactoryGirl.define do
  factory :customer do
    is_active 1
    uuid { UUID.generate(:compact) }

    after :build do |customer, _evaluator|
      customer.entity ||= build(:entity)
      customer.bill_to_location = build(:location, entity: customer.entity)
      customer.ship_to_location = build(:location, entity: customer.entity)
    end
  end
end
