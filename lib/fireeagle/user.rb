class FireEagle
  class User

    #Parses the XML response from FireEagle.
    def initialize(doc)
      doc = Hpricot(doc) unless doc.is_a?(Hpricot::Doc || Hpricot::Elem)
      @doc = doc
    end

    #The User-specific token for this Client.
    def token
      @token ||= @doc.at("/user").attributes["token"]
    end

    #FireEagle's "best guess" form this User's Location. This best guess is derived as the most accurate
    #level of the hierarchy with a timestamp in the last half an hour <b>or</b> as the most accurate
    #level of the hierarchy with the most recent timestamp.
    def best_guess
      @best_guess ||= locations.select { |location| location.best_guess? }.first
    end

    #An Array containing all Location granularity that the Client has been allowed to
    #see for the User. The Location elements returned are arranged in hierarchy order consisting of: 
    #Country, State, County, Large Cities, Neighbourhoods/Local Area, Postal Code and exact location.
    #The Application should therefore be prepared to receive a response that may consist of (1) only
    #country, or (2) country & state or (3) country, state & county and so forth.
    def locations
      @locations ||= @doc.search("/user/location-hierarchy/location").map do |location|
        FireEagle::Location.new(location.to_s)
      end
    end
  end
end