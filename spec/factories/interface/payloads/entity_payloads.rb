FactoryGirl.define do
  factory :entity_payload, class: Interface::Payloads::EntityPayload do
    entity_type { %w{company person}.sample }
    name { Faker::Company.name }
    reference { Faker::Number.number(8) }
    uuid { UUID.generate(:compact) }

    trait :with_contact do
      after :build do |payload, _evaluator|
        payload.contacts << build(:contact_payload)
      end
    end

    trait :with_customer do
      after :build do |payload, _evaluator|
        payload.customer = build(:customer_payload)
      end
    end

    trait :with_location do
      after :build do |payload, _evaluator|
        payload.locations << build(:location_payload)
      end
    end
  end
end
