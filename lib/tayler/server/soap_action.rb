require 'nokogiri'

module Tayler
  module Server
    class SoapAction
      class << self
        attr_accessor :soap_action_name, :request_parser, :response_formatter,
                      :response_namespace_value, :additional_namespaces
        def handles?(name)
          @soap_action_name == name.gsub('"', '')
        end

        def request(&block)
          @request_parser = block
        end

        def response(&block)
          @response_formatter = block
        end

        def action_name(name)
          @soap_action_name = name
        end

        def response_namespace(prefix, href)
          @response_namespace_value = { prefix: prefix, href: href }
        end

        def add_namespace(prefix, href)
          @additional_namespaces ||= []
          @additional_namespaces << { prefix: prefix, href: href }
        end
      end

      def initialize(request_body)
        unless request_body.blank?
          @raw_request = request_body
          @xml_request = Nokogiri::XML.parse(@raw_request)
          parse_namespaces!
        end
      end

      def request_envelope
        @request_envelope ||= @xml_request.xpath("/#{@soap_namespace.prefix}:Envelope[1]").first
      end

      def request_body
        @request_body ||= request_envelope.xpath("#{@soap_namespace.prefix}:Body/*[local-name() = '#{self.class.soap_action_name}']").first
      end

      def parsed_body
        @parsed_body ||= self.class.request_parser.call request_body
      end

      def run
        response = process(parsed_body)

        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')

        wrap_in_response_envelope(builder) do |env_builder|
          self.class.response_formatter.call(env_builder, response)
        end

        builder
      end

      def parse_namespaces!
        @soap_namespace = @xml_request.document.root.namespace
        @namespaces = @xml_request.document.root.namespace_definitions
        @request_namespace = request_body.namespace.try(:prefix)
      end
      private :parse_namespaces!

      def wrap_in_response_envelope(builder, &block)
        builder.Envelope do |xml|
          @namespaces.each do |ns|
            xml.doc.root.add_namespace_definition ns.prefix, ns.href
          end
          (self.class.additional_namespaces || []).each do |ns|
            xml.doc.root.add_namespace_definition ns[:prefix], ns[:href]
          end
          response_ns = xml.doc.root.add_namespace_definition self.class.response_namespace_value[:prefix], self.class.response_namespace_value[:href]
          xml.doc.root.namespace = xml.doc.root.namespace_definitions.detect { |ns| ns.prefix == @soap_namespace.prefix }
          xml.Body do
            xml[response_ns.prefix].send("#{self.class.soap_action_name}Response") do
              block.call(xml)
            end
          end
        end
      end
      private :wrap_in_response_envelope
    end
  end
end
