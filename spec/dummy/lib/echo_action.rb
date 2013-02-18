class EchoAction < Tayler::SoapAction
  action_name "echo"

  request do |xml|
    val = xml.xpath('whatToEcho').first.text
    { :what_to_echo => val }
  end

  response do |xml, resp|
    xml.whatWasEchoed resp[:what_was_echoed]
  end

  def process(body)
    { :what_was_echoed => body[:what_to_echo] }
  end
end
