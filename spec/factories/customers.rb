FactoryGirl.define do
  factory :customer do
    entity
    is_active 1
    uuid { UUID.generate(:compact) }
    _v 1

    after :build do |customer, _evaluator|
      customer.entity ||= build(:entity)
      customer.bill_to_location ||= build(:location, entity: customer.entity)
      customer.ship_to_location ||= build(:location, entity: customer.entity)
    end
  end
end
