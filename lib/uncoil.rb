#!/usr/bin/env ruby

require 'bitly'
require 'open-uri'
require 'net/http'

BITLY_API_KEY = {:user => "stim371", :key => "R_7a6f6d845668a8a7bb3e0c80ee3c28d6"}
ROOT_URL = "http://is.gd/forward.php?format=json&callback=myfunction&shorturl="
USER_AGENT = "is_gd ruby library http://is-gd.rubyforge.org"

class Uncoil
    
  class << self

    def identify_domain short_url
      split_array = short_url.split("/")
      if split_array.length > 2
        split_array[2].to_s
      else
        raise ArgumentError, "The url is too short!"
      end
    end

    def expand short_url
      short_url = "http://"  << short_url unless short_url =~ /^https?:\/\//
      short_url.chop! if short_url[-1] == "/"
      short_url
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

      @long_url = open(ROOT_URL + "#{short_url}") { |file| file.read }
      #need to figure out how to extract text
      #is there an easier way than just parsing it?
    end

    def uncoil_other short_url, depth = 10

    end

  end
end