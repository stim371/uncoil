require 'open-uri'

class DomainFinder
  def domain_for(short_url)
    #TODO: new object here?
    match_host_to_provider(host_for(short_url))
  end

  def host_for(url)
    URI.parse(url).host
  end

  def match_host_to_provider(host)
    case
    when bitly_domains.include?(host)
      :bitly
    when isgd_domains.include?(host)
      :isgd
    else
      host
    end
  end

  private

  def bitly_domains
    %w[bit.ly j.mp bitlypro.com cs.pn nyti.ms]
  end

  def isgd_domains
    'is.gd'
  end
end
