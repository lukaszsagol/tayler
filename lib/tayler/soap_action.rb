require 'nokogiri'

module Tayler
  class SoapAction
    class << self
      def request(&block)
        @@request_parser = block
      end

      def response(&block)
        @@response_formatter = block
      end
    end

    def initialize(request_body)
      @raw_request = request_body
      @parsed_request = Nokogiri::XML.parse(@raw_request)
    end

    def process
    end
  end
end
