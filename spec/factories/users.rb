FactoryGirl.define do
  factory :user do
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :authenticated do
      after :build do |user, _evaluator|
        user.add_role :authenticated
      end
    end

    trait :admin do
      authenticated

      after :build do |user, _evaluator|
        user.add_role :admin
      end
    end
  end
end
