FactoryGirl.define do
  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    display_name { "#{first_name} #{last_name}" }
    email_address { Faker::Internet.email }
    fax_number { Faker::PhoneNumber.phone_number }
    mobile_number { Faker::PhoneNumber.cell_phone }
    phone_number { Faker::PhoneNumber.phone_number }
    uuid { UUID.generate(:compact) }
  end
end
