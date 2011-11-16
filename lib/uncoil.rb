#!/usr/bin/env ruby

require 'bitly'
require 'open-uri'
require 'net/http'
require 'json'

class Uncoil
  ISGD_ROOT_URL = "http://is.gd/forward.php?format=json&shorturl="
  USER_AGENT = "is_gd ruby library http://is-gd.rubyforge.org"
  BITLY_DOM_ARRAY = %w[bit.ly, j.mp, bitlypro.com, cs.pn, nyti.ms]
  FAILING_API_DOMAINS = %w[xhref.com]
  
  #attr_accessor :short_url
  #attr_reader :long_url, :error
  
    def initialize options = {}
      Bitly.use_api_version_3
      @bitly_instance = Bitly.new("#{options[:bitlyuser]}", "#{options[:bitlykey]}")
    end

    def identify_domain short_url
      split_array = short_url.split("/")
      split_array.length > 2 ? split_array[2].to_s : raise(ArgumentError, "The url is too short!")
    end

    def clean_url short_url
      short_url = "http://" << short_url unless short_url =~ /^https?:\/\//
      short_url.chop! if short_url[-1] == "/"
      short_url
    end

    def expand url_arr
      #output a hash with short_url, long_url, error if present
      out_arr = Array(url_arr).flatten.map do |short_url|
        error     = nil
        short_url = clean_url(short_url)
        domain    = identify_domain(short_url)
        
          unless FAILING_API_DOMAINS.include? domain
            if BITLY_DOM_ARRAY.include? domain
              long_url = uncoil_bitly(short_url)
            elsif check_bitly_pro(domain)
              long_url = uncoil_bitly(short_url)
            elsif domain == "is.gd"
              long_url = uncoil_isgd(short_url)
            else
              long_url = uncoil_other(short_url)
            end
          else
            error = "Unsupported domain"
            #raise ArgumentError, "expansion for the #{domain} domain is not currently supported."
          end
          
          { :short_url => short_url , :long_url => long_url, :error => error }
          
      end
      out_arr.length == 1 ? out_arr[0] : out_arr
    end

    def check_bitly_pro url_domain
      @bitly_instance.bitly_pro_domain(url_domain)
    end

    def uncoil_bitly short_url
      @bitly_instance.expand(short_url).long_url
    end

    def uncoil_isgd short_url
      JSON.parse(open(ISGD_ROOT_URL + "#{short_url}") { |file| file.read })["url"]
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