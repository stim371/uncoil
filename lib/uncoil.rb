require 'uncoil/domain_finder'
require 'uncoil/expander'
require 'uncoil/response'

require 'bitly'

class Uncoil
  def initialize(options = {})
    Bitly.use_api_version_3

    if options.has_key?(:bitlyuser) && options.has_key?(:bitlykey)
      @bitly_instance = Bitly.new("#{options[:bitlyuser]}", "#{options[:bitlykey]}")
    end
  end
  
  def self.expand(urls)
    Uncoil.new.expand(urls)
  end

  def expand(urls)
    format_output(expand_all(urls))
  end

  private

  def expand_all(urls)
    Array(urls).flatten.map { |short_url| response_for(short_url) }
  end

  def response_for(url)
    response = Response.new({:short_url => url})
    begin
      response.long_url = Expander.expand(url, @bitly_instance)
    rescue => exception
      response.long_url, response.error = nil, exception.message
    end
    response
  end

  def format_output(output_array)
    output_array.length == 1 ? output_array[0] : output_array
  end
end
