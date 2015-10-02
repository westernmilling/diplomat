FactoryGirl.define do
  factory :customer_payload, class: Interface::Payloads::CustomerPayload do
    credit_limit 0
  end
end
