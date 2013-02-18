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

      def action_name(name)
        @@soap_action_name = name
      end
    end

    def initialize(request_body)
      @raw_request = request_body
      @xml_request = Nokogiri::XML.parse(@raw_request)
      parse_namespaces!
    end

    def request_envelope
      @request_envelope ||= @xml_request.xpath("/#{@soap_namespace.prefix}:Envelope[1]").first
    end

    def request_body
      @request_body ||= request_envelope.xpath("#{@soap_namespace.prefix}:Body/*[local-name() = '#{@@soap_action_name}']").first
    end

    def parsed_body
      @@parsed_body ||= @@request_parser.call request_body
    end

    def run
      response = process(parsed_body)
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')
      body_block = prepare_response_envelope(builder)
      @@response_formatter.call(body_block, response)
      builder.to_xml
    end

    def parse_namespaces!
      @soap_namespace = @xml_request.document.root.namespace
      @request_namespace = request_body.namespace.try(:prefix)
    end
    private :parse_namespaces!

    def prepare_response_envelope(builder)
      builder.Envelope do |xml|
        soap_ns = xml.doc.root.add_namespace_definition(@soap_namespace.prefix, @soap_namespace.href)
        xml.doc.root.namespace = soap_ns
      end
    end
    private :prepare_response_envelope
  end
end
