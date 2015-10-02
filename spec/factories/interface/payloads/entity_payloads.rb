FactoryGirl.define do
  factory :entity_payload, class: Interface::Payloads::EntityPayload do
    entity_type { %w{company person}.sample }
    name Faker::Company.name
    reference Faker::Number.number(8)
    uuid UUID.generate(:compact)
  end
end
