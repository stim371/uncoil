require 'bitly'
require_relative 'uncoil_submethods'

# @author Joel Stimson
class Uncoil
  ISGD_ROOT_URL = "http://is.gd/forward.php?format=json&shorturl="
  BITLY_DOM_ARRAY = %w[bit.ly, j.mp, bitlypro.com, cs.pn, nyti.ms]
  
  # Creates a new Uncoil object and will log into Bit.ly if you provide credentials
  #
  # @option options [String] :bitlyuser A key for your Bit.ly API username
  # @option options [String] :bitlykey A key for your Bit.ly API key
  # 
  # @return [Class] the new instance of the Uncoil class
  # 
  # @example Set up a new instance
  #  Uncoil.new(:bitlyuser => CREDENTIALS['bitlyuser'], :bitlykey => CREDENTIALS['bitlykey']) => "#<Uncoil:0x00000102560d30 @bitly_access=true>"
  #
  def initialize options = {}
    Bitly.use_api_version_3
    @bitly_access = false
    
    # create bitly instance if the auth criteria are all entered by user
    if options.has_key?(:bitlyuser) && options.has_key?(:bitlykey)
      @bitly_instance = Bitly.new("#{options[:bitlyuser]}", "#{options[:bitlykey]}")
      @bitly_access = true
    end
  end
  
  # A class method version of the main expand method. This will not have access to the bit.ly API, but it's faster than having to create an instance and then use it for a one-off request.
  #
  # @param [String, Array] short_url The single url or array of urls you would like to expand
  #
  # @example Use the class method for a one-off request
  #  Uncoil.expand("http://tinyurl.com/736swvl") # => #<Uncoil::Response:0x00000101ed9250 @long_url="http://www.chinadaily.com.cn/usa/business/2011-11/08/content_14057648.htm", @short_url="http://tinyurl.com/736swvl", @error=nil> 
  #
  def self.expand short_url
    Uncoil.new.expand(short_url)
  end

  # The main method used for all requests. This method will delegate to submethods based on the domain of the link given.
  #
  # @param [String, Array] url_arr This can be a single url as a String or an array of Strings that the method will expand in order
  #
  # @return [Uncoil::Response] Returns a response object with getters for the long and short url
  # 
  def expand url_arr
    output_array = Array(url_arr).flatten.map do |short_url|
      short_url  = clean_url(short_url)
      domain     = identify_domain(short_url)
      
      begin
        long_url = 
          if @bitly_access && ( BITLY_DOM_ARRAY.include?(domain) || check_bitly_pro(domain) )
            uncoil_bitly(short_url)
          elsif domain == "is.gd"
            uncoil_isgd(short_url)
          else
            uncoil_other(short_url)
          end
      rescue => exception
        long_url = nil
        error = exception.message
      end
      # return a response object for each time through the loop
      Response.new(long_url, short_url, error)
    end
    # here's the return
    output_array.length == 1 ? output_array[0] : output_array
  end


  # Contacts the bit.ly API to see if the domain is a bitlypro domain, which are custom domains purchased by 3rd parties but managed by bit.ly
  #
  # @param [String] url_domain The domain to check against the bit.ly API.
  #
  def check_bitly_pro url_domain
    @bitly_instance.bitly_pro_domain(url_domain)
  end
  
  
  # Extracts the domain from the link to help match it with the right sub-method to expand the url
  #
  # @param [String] short_url A single url to extract a domain from.
  #
  def identify_domain short_url
    clean_url(short_url).split("/")[2].to_s
  end
  

  # Standardizes the url by adding a protocol if there isn't one and removing trailing slashes
  #
  # @param [String] short_url A single url to be cleaned up.
  #
  def clean_url short_url
    short_url = "http://" << short_url unless short_url =~ /^https?:\/\//
    short_url.chop! if short_url[-1] == "/"
    short_url
  end
  
end


class Uncoil::Response
  attr_reader :long_url, :short_url, :error
  
  # Creates a new Response object with attributes for the original and short url, as well as any errors that occured. It is called at the end of 'expand' method.
  #
  # @param [String] long_url The expanded url that we were looking for.
  # @param [String] short_url The original, short url that we used to look up the long url.
  # @param [String] error The error output if anything went wrong during the request. And I mean ANYTHING from a code error to an HTTP issue. It catches it all.
  #
  def initialize(long_url, short_url, error)
    @long_url = long_url
    @short_url = short_url
    @error = error
  end
end
