class FireEagle::Application < FireEagle::APIBase
  #A user must authorize (or grant permissions to) an application before the application can write or read the user's location. This authorization process begins by directing a user to the authorization page, where the user logs in and chooses which permissions to grant to the requesting application. The authorization page generates a user token, specific to the requesting application, which can be returned to the requesting application in several ways:
  # 
  #1. User token passed back to requesting application via callback URL (if the callback parameter is supplied)
  #2. User token displayed onscreen (this is good for testing, but will likely be phased out or modified in the future)
  #3. User token is exchanged at a later time (good for mobile devices where a user may not want to enter their Yahoo! username/password)
  #   
  def authorize_url(callback_url = "")
    "http://#{FireEagle::API_DOMAIN}/authorize.php?appid=#{@fireeagle.token}&callback=#{CGI::escape(callback_url)}"
  end

  
  #Applications which do not maintain a user repository (for example, a lightweight mobile application) may not wish to use the callback mechanism described above. These applications still must send users to authorize.php, but do not expect an immediate response (though at the moment, the authorize page will display the user token for easy testing and debugging). After the user has authorized an application, the application can later retrieve the user token in exchange for a short code obtained by the user from the Fire Eagle site. The user would retrieve a short code from the FE site and enter the code into the application which would then use the exchangeToken.php to exchange the short code for a full user token.
  # 
  #To obtain a short code users visit http://fireeagle.research.yahoo.com/displayToken.php?appid=TOKEN, where app token is the application token.
  #
  #Returnes an instance of FireEagle::User 
  def exchange_token(shortcode = nil)
    raise FireEagle::ArgumentError, "Shortcode required" if shortcode.nil?
    request("exchangeToken", :shortcode => shortcode.to_s)
  end
  
private
  
  def parse_response(doc)
    raise FireEagle::FireEagleException, doc.at("/resultset/errormessage").innerText unless doc.at("/resultset").nil?
    FireEagle::User.new_from_xml(@fireeagle, doc)
  end
end