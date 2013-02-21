require 'nokogiri'

module Tayler
  module Faults
    class SoapError < StandardError
      def initialize(code, string)
        @code = code
        @string = string
        @default_namespace = {prefix: 'soap-env', href: 'http://schemas.xmlsoap.org/soap/envelope/'}
        @namespaces = [
          { prefix: 'xsi', href: "http://www.w3.org/1999/XMLSchema-instance" },
          { prefix: 'xsd', href: "http://www.w3.org/1999/XMLSchema" }
        ]
      end

      def to_xml(*args)
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')
        builder.Envelope do |xml|
          @namespaces.each do |ns|
            xml.doc.root.add_namespace_definition ns[:prefix], ns[:href]
          end
          ns = xml.doc.root.add_namespace_definition @default_namespace[:prefix], @default_namespace[:href]
          xml.doc.root.namespace = ns
          xml.Body do
            xml.Fault do
              xml.faultcode(@code, 'xsi:type' => "xsd:string")
              xml.faulstring(@string, 'xsi:type' => "xsd:string")
            end
          end
        end

        builder.to_xml(*args)
      end
    end

    class ActionNotFound < SoapError
      def initialize(action_name)
        super("Client", "Failed to locate action (#{action_name})")
      end
    end
  end
end
