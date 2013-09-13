require 'simplecov'
require 'vcr'
require 'webmock/rspec'
SimpleCov.start

require 'uncoil'

CREDENTIALS = YAML.load_file("./credentials.yml")['bitly']

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/uncoil_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    :record => :new_episodes
  }
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end