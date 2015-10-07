module Interface
  module IRely
    module ApiClient
      class Result < Struct.new(:hash_response, :raw_response)
        def initialize(response)
          @hash_response = response.to_snake_keys
          @raw_response = response
        end
      end
    end
  end
end
