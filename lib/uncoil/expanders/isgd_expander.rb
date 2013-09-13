require 'json'
require 'typhoeus'

class IsgdExpander
  ISGD_ROOT_URL = "http://is.gd/forward.php?format=json&shorturl="

  class << self
    def expand(short_url)
      response = Typhoeus.get("#{ISGD_ROOT_URL}#{short_url}")
      isgd_location_from_response(response.response_body)
    end

    private

    def isgd_location_from_response(body)
      JSON.parse(body)["url"]
    end
  end
end
