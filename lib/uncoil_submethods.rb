require 'open-uri'
require 'typhoeus'
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
    response = Typhoeus.get("#{ISGD_ROOT_URL}#{short_url}")
    JSON.parse(response.options[:response_body])["url"]
  end

  # Expands any links that do not match the above domains.
  # 
  # @param [String] short_url The short url you would like to expand.
  # @param [Integer, 10] depth The number of redirects you would like this method to follow.
  #
  def uncoil_other short_url
    response = Typhoeus.get(short_url, :followlocation => true)
    response.options[:effective_url]
  end
  
end
