require 'spec_helper'

module Tayler
  describe SoapAction do
    context "example echo service" do
      before do
        @request = load_xml('echo_request.xml')
        # parse and convert with Nokogiri to avoid whitespace issues
        @response = Nokogiri::XML.parse(load_xml('echo_response.xml')).to_xml
      end

      it "responds with the same message it received" do
        expect(EchoAction.new(@request).run.to_xml).to eq(@response)
      end
    end

    context "setup" do
      before do
        @it = EchoAction
        @request_parser = EchoAction.class_variable_get(:@@request_parser)
        @response_formatter = EchoAction.class_variable_get(:@@response_formatter)
        @proc = Proc.new { 'test' }
      end

      it "allows to provide own request parsing block" do
        @it.request(&@proc)
        expect(@it.class_variable_get(:@@request_parser)).to eq(@proc)
      end

      it "allows to provide own response formatting block" do
        @it.response(&@proc)
        expect(@it.class_variable_get(:@@response_formatter)).to eq(@proc)
      end

      after do
        EchoAction.request(&@request_parser)
        EchoAction.response(&@response_formatter)
      end
    end

    context "initialization" do
      before do
        @request = load_xml('echo_request.xml')
        @it = EchoAction.new(@request)
      end

      it "accepts request body" do
        expect(@it.instance_variable_get(:@raw_request)).to eq(@request)
      end

      it "parses request XML" do
        expect(@it.instance_variable_get(:@xml_request)).to be_instance_of(Nokogiri::XML::Document)
      end

      it "parses request with block provided" do
        expect(@it.parsed_body).to eq({:what_to_echo => "I am going to be echoed"})
      end
    end

    context "parsing" do
      before do
        request = load_xml('echo_request.xml')
        @it = EchoAction.new(request)
        @action_name = EchoAction.class_variable_get(:@@soap_action_name)
        @xml = Nokogiri::XML.parse(request)
      end

      it "must extract request envelope" do
        expect(@it.request_envelope.name).to eq("Envelope")
      end

      it "must extract body block from request xml" do
        expect(@it.request_body.name).to eq(@action_name)
      end
    end

    context "processing" do
      before do
        @request = load_xml('echo_request.xml')
        @it = EchoAction.new(@request)
      end

      it "has process method" do
        expect { @it.public_method(:process) }.not_to raise_error(NameError)
      end

      it "returns hash with response" do
        expect(@it.process(@it.parsed_body)).to eq({:what_was_echoed => "I am going to be echoed"})
      end
    end
  end
end
