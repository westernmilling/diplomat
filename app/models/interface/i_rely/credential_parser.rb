module Interface
  module IRely
    # Parses out the parts of an "encoded" credential string.
    class CredentialParser
      def inititalize(credentials)
        @credentials = credentials
      end

      def parse_into(to)
        first_delim = credentials.index(':')
        last_delim = credentials.rindex('@')

        to.api_key = credentials[0, first_delim]
        to.api_secret = credentials[first_delim + 1..last_delim - 1]
        to.company_id = credentials[last_delim + 1..credentials.length]
      end
    end
  end
end
