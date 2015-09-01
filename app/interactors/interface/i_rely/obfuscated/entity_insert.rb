require 'faker'

module Interface
  module IRely
    module Obfuscated
      class EntityInsert < ::Interface::IRely::EntityInsert
        protected

        def company_name
          @company_name ||= Faker::Company.name
        end

        def translate_entity
          {
            id: entity.reference.to_i,
            name: company_name,
            contacts: translated_contacts,
            locations: translated_locations,
            customer: {
              type: entity.entity_type.capitalize,
              creditlimit: 0
            }
          }
        end

        def translated_contacts
          entity.contacts.map do |contact|
            {
              name: Faker::Name.name,
              phone: Faker::PhoneNumber.phone_number,
              fax: Faker::PhoneNumber.phone_number,
              mobile: Faker::PhoneNumber.phone_number,
              email: Faker::Internet.email,
              id: contact.id
            }
          end
        end

        def translated_locations
          entity.locations.map.with_index(1) do |location, index|
            {
              name: "#{company_name} #{index}",
              address: Faker::Address.street_address,
              city: Faker::Address.city,
              state: Faker::Address.state,
              zipcode: Faker::Address.zip_code,
              country: Faker::Address.country,
              termsId: 'Due on Receipt',
              id: location.id
            }
          end
        end
      end
    end
  end
end
