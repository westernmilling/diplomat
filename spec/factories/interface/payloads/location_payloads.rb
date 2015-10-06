FactoryGirl.define do
  factory :location_payload, class: Interface::Payloads::LocationPayload do
    city { Faker::Address.city }
    country { 'United States' }
    fax_number { Faker::PhoneNumber.phone_number }
    phone_number { Faker::PhoneNumber.phone_number }
    region { Faker::Address.state }
    region_code { Faker::Address.zip_code }
    street_address { Faker::Address.street_address }
    uuid { UUID.generate(:compact) }
  end
end
