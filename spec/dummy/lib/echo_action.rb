class EchoAction < Tayler::Server::SoapAction
  action_name "echo"
  response_namespace "namesp24", "urn:Echo"

  request do |xml|
    val = xml.xpath('namesp1:whatToEcho').first.text
    { :what_to_echo => val }
  end

  response do |xml, resp|
    xml.whatWasEchoed resp[:what_was_echoed]
  end

  def process(body)
    { :what_was_echoed => body[:what_to_echo] }
  end
end
