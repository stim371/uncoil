require 'simplecov'
SimpleCov.start
CREDENTIALS = YAML.load_file("./credentials.yml")['bitly']