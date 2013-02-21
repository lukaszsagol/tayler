require 'spec_helper'

describe "Tayler router" do
  it "should route to echo action" do
    post '/tayler', load_xml('echo_request.xml'), {'HTTP_SOAPACTION' => 'echo'}
    expect(response.body).to eq(Nokogiri::XML.parse(load_xml('echo_response.xml')).to_xml)
  end

  it "should throw error when incorrect action" do
    post '/tayler', load_xml('echo_request.xml'), {'HTTP_SOAPACTION' => 'inexistent'}
    expect(response.body).to eq(Nokogiri::XML.parse(load_xml('action_not_found_response.xml')).to_xml)
  end
end
