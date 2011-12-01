#!/usr/bin/env ruby

require 'bitly'
require 'open-uri'
require 'net/http'
require 'json'

class Uncoil
  ISGD_ROOT_URL = "http://is.gd/forward.php?format=json&shorturl="
  BITLY_DOM_ARRAY = %w[bit.ly, j.mp, bitlypro.com, cs.pn, nyti.ms]
  FAILING_API_DOMAINS = %w[xhref.com]
  
    def initialize options = {}
      Bitly.use_api_version_3
      @bitly_access = false
      
      if options.has_key?(:bitlyuser) && options.has_key?(:bitlykey)
        @bitly_instance = Bitly.new("#{options[:bitlyuser]}", "#{options[:bitlykey]}")
        @bitly_access = true
      end
    end

    def identify_domain short_url
      clean_url(short_url).split("/")[2].to_s
    end

    def clean_url short_url
      short_url = "http://" << short_url unless short_url =~ /^https?:\/\//
      short_url.chop! if short_url[-1] == "/"
      short_url
    end

    def expand url_arr
      out_arr = Array(url_arr).flatten.map do |short_url|
        short_url = clean_url(short_url)
        domain    = identify_domain(short_url)
        
        @bitly_access.nil? ? error = "Not logged in to Bitly API" : error = nil
        
        unless FAILING_API_DOMAINS.include? domain
          begin
            if @bitly_access && BITLY_DOM_ARRAY.include?(domain)
              long_url = uncoil_bitly(short_url)
            elsif @bitly_access && check_bitly_pro(domain)
              long_url = uncoil_bitly(short_url)
            elsif domain == "is.gd"
              long_url = uncoil_isgd(short_url)
            else
              long_url = uncoil_other(short_url)
            end
          rescue => exception
            long_url = nil
            error = exception.message
          end
        else
          long_url = nil
          error = "Unsupported domain"
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