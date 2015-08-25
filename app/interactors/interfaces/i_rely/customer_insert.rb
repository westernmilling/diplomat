module Interfaces
  module IRely
    class CustomerInsert
      include Interactor

      delegate :customer, to: :context

      def call
        hash = {
          id: customer.entity.reference,
          name: customer.entity.name,
          customer: {
            type: customer.entity.entity_type
          },
          custom: {
            uuid: customer.entity.uuid
          }
        }

        response = connection.post do |req|
          req.headers['Content-Type'] = 'application/json'
          # TODO: Key and Secret can probably stay in env and not in Integration
          req.headers['Authorization'] = "bearer #{Figaro.env.IRELY_API_KEY}.#{Figaro.env.IRELY_API_SECRET}"
          # TODO: Move Company into Integration model
          req.headers['ICompany'] = Figaro.env.IRELY_COMPANY
          req.body = hash.to_json
        end
      end

      protected

      def connection
        Faraday.new(url: url)
      end

      def url
        # TODO: Store base URL in env and remove from Integration
        "#{Figaro.env.IRELY_BASE_URL}entitymanagement/api/entity/import"
      end
    end
  end
end
