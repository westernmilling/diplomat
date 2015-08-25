FactoryGirl.define do
  factory :integration do
    address Faker::Internet.url
    credentials "#{Faker::Internet.user_name}:#{Faker::Internet.password}"
    integration_type 'irely'
    sequence(:name) { |n| "Integration #{n}" }
    uuid { UUID.generate(:compact) }
  end
end
