require_relative './expanders/default_expander'
require_relative './expanders/bitly_expander'
require_relative './expanders/isgd_expander'

module Expander
  class << self
    def expand(short_url, bitly_instance = nil)
      case 
      when domain_for(short_url) == :bitly && bitly_instance
        BitlyExpander.expand(short_url, bitly_instance)
      when domain_for(short_url) == :isgd
        IsgdExpander.expand(short_url)
      else
        DefaultExpander.expand(short_url)
      end
    end

    private

    def domain_for(short_url)
      DomainFinder.new.domain_for(short_url)
    end
  end
end
