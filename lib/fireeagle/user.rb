class FireEagle::User < FireEagle::APIBase
  attr_reader :token
  
  #Create a new instance of FireEagle::User. Requires a FireEagle::Base object, and the users app-specific token 
  def initialize(fireeagle, token)
    super(fireeagle)
    @fireeagle = fireeagle
    @token = token.to_s
  end
  
  class << self
    #Create a new instance of FireEagle::User from the XML returned from Yahoo!
    def new_from_xml(fireeagle, doc)
      FireEagle::User.new(fireeagle, doc.at("/rsp/token").innerText)
    end
  end
  
  #Returns a FireEagle::Location instance describing the User's current location
  def location
    request("queryLoc", :userid => self.token)
  end
  
  #Sets the User's location to that described in an FireEagle::Location object
  def location=(location)
    raise FireEagle::ArgumentError, "FireEagle::Location required" unless location.is_a?(FireEagle::Location)
    returning(location) do
      request("updateLoc", location.details.merge(:userid => self.token))
    end
  end
  
private
  
  def parse_response(doc)
    raise FireEagle::FireEagleException, doc.at("/resultset/errormessage").innerText if doc.at("/resultset/error").innerText.to_i != 0
    return if doc.at("/resultset/result").nil? 
    FireEagle::Location.new_from_xml(doc)
  end
  
end