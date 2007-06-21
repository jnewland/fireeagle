class FireEagle::Application < FireEagle::APIBase
  def authorize_url(callback_url = "")
    "http://#{FireEagle::API_DOMAIN}/authorize.php?appid=#{@fireeagle.token}&callback=#{CGI::escape(callback_url)}"
  end

  def exchange_token(shortcode = nil)
    raise ArgumentError, "Shortcode required" if shortcode.nil?
    request("exchangeToken", :shortcode => shortcode.to_s)
  end
  
private
  
  def parse_response(doc)
    raise FireEagleException, doc.at("/resultset/errormessage").innerText unless doc.at("/resultset").nil?
    User.new_from_xml(@fireeagle, doc)
  end
end