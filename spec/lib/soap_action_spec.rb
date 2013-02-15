require 'spec_helper'

module Tayler
  describe SoapAction do
    context "example echo service" do
      before do
        @request = load_xml('echo_request.xml')
        @response = load_xml('echo_response.xml')
      end

      it "responds with the same message it received" do
        expect(EchoAction.new(@request).process).to eq(@response)
      end
    end

    context "setup" do
      before do
        @it = EchoAction
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
        expect(@it.instance_variable_get(:@parsed_request)).to be_instance_of(Nokogiri::XML::Document)
      end

      it "parses request with block provided" do
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
    end
  end
end
