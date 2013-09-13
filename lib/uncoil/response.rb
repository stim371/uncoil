class Uncoil
  class Response
    attr_accessor :long_url, :short_url, :error

    def initialize(attributes = {})
      attributes.each do |k, v|
        self.send("#{k.to_s}=", v)
      end
    end
  end
end
