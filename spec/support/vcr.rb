# encoding: UTF-8
require 'vcr'
require 'webmock/rspec'
require 'rack'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.default_cassette_options = { :record => :none }
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data('%{API_KEY}') { CONTACTOLOGY_CONFIGURATION['key'] }
  config.filter_sensitive_data('%{API_ENDPOINT}') { CONTACTOLOGY_CONFIGURATION['endpoint'] }

  config.register_request_matcher(:api_uri, &VCR.request_matchers.uri_without_param(:newEmail, :email))
end
