require 'open-uri'
require 'net/http'
require 'json'

class Uncoil
  def uncoil_bitly short_url
    @bitly_instance.expand(short_url).long_url
  end

  def uncoil_isgd short_url
    JSON.parse(open(ISGD_ROOT_URL + "#{short_url}") { |file| file.read } )["url"]
  end

  def uncoil_other short_url, depth = 10
    url = URI.encode(short_url)
    response = Net::HTTP.get_response(URI.parse(url))
  
    case response
      when Net::HTTPSuccess     then url
      when Net::HTTPRedirection then uncoil_other(response['location'], depth - 1)
    end
  end
end