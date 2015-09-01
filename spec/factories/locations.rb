FactoryGirl.define do
  factory :location do
    city { Faker::Address.city }
    country { 'United States' }
    fax_number { Faker::PhoneNumber.phone_number }
    phone_number { Faker::PhoneNumber.phone_number }
    region { Faker::Address.state }
    region_code { Faker::Address.zip_code }
    street_address { Faker::Address.street_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    uuid { UUID.generate(:compact) }
    cached_long_address { long_address }

    after :build do |location, _evaluator|
      location.location_name = location.entity.name
    end
  end
end
