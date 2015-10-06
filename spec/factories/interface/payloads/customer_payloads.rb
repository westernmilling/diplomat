FactoryGirl.define do
  factory :customer_payload, class: Interface::Payloads::CustomerPayload do
    credit_limit 0
    customer_type { %w{company person}.sample }
  end
end
