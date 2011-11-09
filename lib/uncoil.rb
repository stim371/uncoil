#!/usr/bin/env ruby

require 'bitly'
require 'open-uri'
require 'net/http'
require 'json'

#class methods can be called even if there's no instance
#instance methods can be left out of the self group since they will only be called when there is an instance
#this means you will need to update hte spec to create a new class

BITLY_API_KEY = {:user => "stim371", :key => "R_7a6f6d845668a8a7bb3e0c80ee3c28d6"}
ISGD_ROOT_URL = "http://is.gd/forward.php?format=json&shorturl="
USER_AGENT = "is_gd ruby library http://is-gd.rubyforge.org"

class Uncoil
    attr_accessor :short_url
    # attr_reader :long_url
    
#  class << self

    def identify_domain short_url
      split_array = short_url.split("/")
      if split_array.length > 2
        split_array[2].to_s
      else
        raise ArgumentError, "The url is too short!"
      end
    end

    def clean_url short_url
      short_url = "http://"  << short_url unless short_url =~ /^https?:\/\//
      short_url.chop! if short_url[-1] == "/"
      short_url
    end

    def expand url_arr
      url_arr
      out_arr = Array(url_arr).flatten.map do |short_url|
        
        short_url = clean_url(short_url)
        domain = identify_domain(short_url)
      
        if ["bit.ly", "j.mp", "bitlypro.com"].include? domain
          uncoil_bitly(short_url)
        elsif check_bitly_pro(domain)
          uncoil_bitly(short_url)
        elsif domain == "is.gd"
          uncoil_isgd(short_url)
        else
          uncoil_other(short_url)
        end
        
      end
      
      out_arr.length == 1 ? out_arr[0] : out_arr
      
    end

    def check_bitly_pro url_domain, api_key = BITLY_API_KEY
      Bitly.use_api_version_3
      Bitly.new("#{BITLY_API_KEY[:user]}","#{BITLY_API_KEY[:key]}").bitly_pro_domain(url_domain)
    end

    def uncoil_bitly short_url, api_key = BITLY_API_KEY
      Bitly.use_api_version_3
      Bitly.new("#{BITLY_API_KEY[:user]}","#{BITLY_API_KEY[:key]}").expand(short_url).long_url
    end

    def uncoil_isgd short_url
      reply = open(ISGD_ROOT_URL + "#{short_url}") { |file| file.read }
      JSON.parse(reply)["url"]
    end

    def uncoil_other short_url, depth = 10
      url = URI.encode(short_url)

      response = Net::HTTP.get_response(URI.parse(url))
      
      case response
        when Net::HTTPSuccess     then url
        when Net::HTTPRedirection then uncoil_other(response['location'], depth - 1)
        #when Net::HTTPClientError then raise ClientServError
        #when Net::HTTPServerError then raise ClientServError
      end
    end

  #end
end