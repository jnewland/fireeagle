class FireEagle::User < FireEagle::APIBase
  attr_reader :token
  
  def initialize(fireeagle, token)
    super(fireeagle)
    @fireeagle = fireeagle
    @token = token.to_s
  end
  
  class << self
    def new_from_xml(fireeagle, doc)
      FireEagle::User.new(fireeagle, doc.at("/rsp/token").innerText)
    end
  end
  
  def location
    request("queryLoc", :userid => self.token)
  end
  
  def update_location(location)
    raise ArgumentError, "FireEagle::Location required" unless location.is_a?(FireEagle::Location)
    request("updateLoc", location)
  end
  
private
  
  def parse_response(doc)
    raise FireEagleException, doc.at("/resultset/errormessage").innerText if doc.at("/resultset").nil?
    FireEagle::Location.new_from_xml(doc)
  end
  
end