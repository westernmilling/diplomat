FactoryGirl.define do
  factory :user do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :authenticated do
      # No authorization yet
    end
  end
end
