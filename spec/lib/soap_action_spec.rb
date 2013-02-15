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
  end
end
