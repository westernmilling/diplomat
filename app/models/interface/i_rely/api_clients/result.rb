module Interface
  module IRely
    module ApiClients
      Result = Struct.new(:hash_response,
                          :message,
                          :raw_response,
                          :success) do
        def initialize(response)
          self.hash_response = response.to_snake_keys
          self.raw_response = response
          self.message = self.hash_response[:message]
          self.success = self.hash_response[:success] || false
        end
      end
    end
  end
end
