require 'faker'

module Interface
  module IRely
    module Obfuscated
      class EntityInsert < ::Interface::IRely::EntityInsert
        before :extract_credentials

        protected

        def company_name
          @company_name ||= Faker::Company.name
        end

        def translate_request
          {
            id: request[:id],
            name: company_name,
            contacts: translate_contacts(request[:contacts]),
            locations: translate_locations(request[:locations]),
            customer: translate_customer(request)
          }
        end

        def translate_contacts(request)
          request.map do |contact_request|
            {
              name: Faker::Name.name,
              phone: Faker::PhoneNumber.phone_number,
              fax: Faker::PhoneNumber.phone_number,
              mobile: Faker::PhoneNumber.phone_number,
              email: Faker::Internet.email,
              id: contact_request[:id]
            }
          end
        end

        def translate_locations(request)
          request.map.with_index(1) do |location_request, index|
            {
              name: "#{company_name} #{index}",
              address: Faker::Address.street_address,
              city: Faker::Address.city,
              state: Faker::Address.state,
              zipcode: Faker::Address.zip_code,
              country: Faker::Address.country,
              termsId: 'Due on Receipt',
              id: location_request[:id]
            }
          end
        end
      end
    end
  end
end
