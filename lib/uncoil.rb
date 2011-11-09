#!/usr/bin/env ruby

require 'bitly'
require 'open-uri'
require 'net/http'
require 'json'

#class methods can be called even if there's no instance
#instance methods can be left out of the self group since they will only be called when there is an instance
#this means you will need to update hte spec to create a new class

#BITLY_API_KEY = {:user => "stim371", :key => "R_7a6f6d845668a8a7bb3e0c80ee3c28d6"}
ISGD_ROOT_URL = "http://is.gd/forward.php?format=json&shorturl="
USER_AGENT = "is_gd ruby library http://is-gd.rubyforge.org"
BITLY_DOM_ARRAY = ["bit.ly", "j.mp", "bitlypro.com"]

class Uncoil
    
    def initialize( options = {} )
      @api_available = nil
      if options
        Bitly.use_api_version_3
        @bitly_instance = Bitly.new("#{options[:bitlyuser]}", "#{options[:bitlykey]}")
        @api_available = true
      end
    end

    def identify_domain short_url
      split_array = short_url.split("/")
      split_array.length > 2 ? split_array[2].to_s : raise(ArgumentError, "The url is too short!")
    end

    def clean_url short_url
      short_url = "http://"  << short_url unless short_url =~ /^https?:\/\//
      short_url.chop! if short_url[-1] == "/"
      short_url
    end

    def expand url_arr
      out_arr = Array(url_arr).flatten.map do |short_url|
        
        short_url = clean_url(short_url)
        domain = identify_domain(short_url)
      
        if BITLY_DOM_ARRAY.include? domain
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

    def check_bitly_pro url_domain#, api_key = BITLY_API_KEY
      @bitly_instance.bitly_pro_domain(url_domain)
    end

    def uncoil_bitly short_url#, api_key = BITLY_API_KEY
      @bitly_instance.expand(short_url).long_url
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
end