require 'open-uri'
require 'net/http'

class DefaultExpander
  class << self
    def expand(short_url)
      response = Typhoeus.head(short_url, :followlocation => true)
      location_from_response(response)
    end

    private

    def location_from_response(response)
      response.options[:effective_url]
    end
  end
end
