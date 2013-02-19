describe "Tayler router" do
  it "should route to echo action" do
    post '/tayler', load_xml('echo_request.xml'), {'HTTP_SOAPACTION' => 'echo'}
    expect(response.body).to eq(Nokogiri::XML.parse(load_xml('echo_response.xml')).to_xml)
  end
end
