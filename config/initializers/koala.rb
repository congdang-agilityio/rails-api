require 'koala'

Koala.configure do |config|
  config.api_version = 'v2.3'
  # other common options are `rest_server` and `dialog_host`
  # see lib/koala/http_service.rb
end
