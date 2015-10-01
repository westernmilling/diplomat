module Interface
  module IRely
    class Credentials < Struct.new(:api_key, :api_secret, :company_id)
    end
  end
end
