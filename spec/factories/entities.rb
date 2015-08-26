FactoryGirl.define do
  factory :entity do
    cached_long_name { "#{reference} - #{name}" }
    display_name { name }
    entity_type Entity.entity_type.values.sample
    federal_tax_id { Faker::Company.ein }
    is_active 1
    is_withholding { [0, 1].sample }
    name { Faker::Company.name }
    reference { Faker::Number.number(8) }
    tax_number { Faker::Number.number(8) }
    tax_state { Faker::Address.state }
    ten99_form { Entity.ten99_form.values.sample }
    ten99_print { [0, 1].sample }
    ten99_signed_at { Time.zone.today }
    ten99_type { Entity.ten99_type.values.sample }
    uuid { UUID.generate(:compact) }

    after :build do |entity, _evaluator|
      entity.contacts << build(:contact, entity: entity) \
        if entity.contacts.empty?
      entity.locations << build(:location, entity: entity) \
        if entity.locations.empty?
    end

    # trait :with_location do
    #   after :build do |entity, _evaluator|
    #     entity.locations << build(:location, entity: entity)
    #   end
    # end
    # trait :with_contact do
    #   after :build do |entity, _evaluator|
    #     entity.contacts << build(:contact, entity: entity)
    #   end
    # end
  end
end
