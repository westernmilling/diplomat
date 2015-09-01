require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<IRELY_BASE_URL>') { Figaro.env.IRELY_BASE_URL }
  config.filter_sensitive_data('<IRELY_COMPANY>') { Figaro.env.IRELY_COMPANY }
  config.filter_sensitive_data('<IRELY_API_KEY>') { Figaro.env.IRELY_API_KEY }
  config.filter_sensitive_data('<IRELY_API_SECRET>') do
    Figaro.env.IRELY_API_SECRET
  end
end
