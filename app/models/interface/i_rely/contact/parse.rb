module Interface
  module IRely
    module Contact
      class Parse < Interface::IRely::Parse
        def call
          parse unless no_data?

          self
        end

        def no_data?
          # @response.nil? || @response[:data].nil? || @response[:data].empty?
          @response.nil? || @response[:contacts].empty?
        end

        def parse
          contact_response = @response[:contacts]
            .select { |x| x[:id] == @payload.id }
            .first

          return if contact_response.nil?

          @payload.interface_id = contact_response[:i21_id]
        end
      end
    end
  end
end
