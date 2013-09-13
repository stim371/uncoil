class BitlyExpander
  def self.expand(short_url, bitly_instance)
    bitly_instance.expand(short_url).long_url
  end
end
