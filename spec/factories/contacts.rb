FactoryGirl.define do
  factory :contact do
    full_name { Faker::Name.name }
    email_address { Faker::Internet.email }
    fax_number { Faker::PhoneNumber.phone_number }
    mobile_number { Faker::PhoneNumber.cell_phone }
    phone_number { Faker::PhoneNumber.phone_number }
    uuid { UUID.generate(:compact) }
  end
end
