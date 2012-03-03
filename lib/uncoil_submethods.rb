require 'open-uri'
require 'net/http'
require 'json'

class Uncoil
  
  # Expands any links that are bitly or bitlypro domains as long as you have logged into the bitly API.
  # 
  # @param [String] short_url The short url you would like to expand.
  # 
  def uncoil_bitly short_url
    @bitly_instance.expand(short_url).long_url
  end

  # Expands any links that are isgd domains.
  # 
  # @param [String] short_url The short url you would like to expand.
  #
  def uncoil_isgd short_url
    JSON.parse(open(ISGD_ROOT_URL + "#{short_url}") { |file| file.read } )["url"]
  end

  # Expands any links that do not match the above domains.
  # 
  # @param [String] short_url The short url you would like to expand.
  # @param [Integer, 10] depth The number of redirects you would like this method to follow.
  #
  def uncoil_other short_url, depth = 10
    url = URI.encode(short_url)
    response = Net::HTTP.get_response(URI.parse(url))
  
    case response
      when Net::HTTPSuccess     then url
      when Net::HTTPRedirection then uncoil_other(response['location'], depth - 1)
    end
  end
  
end
