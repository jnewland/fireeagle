class FireEagle
  class User

    attr_reader :token, :best_guess, :locations

    #Parses the XML response from FireEagle
    def initialize(doc)
      doc = Hpricot(doc) unless doc.is_a?(Hpricot::Doc || Hpricot::Elem)
      @token = doc.at("/user").attributes["token"]
      @locations = doc.search("/user/location-hierarchy/location").map do |location|
        FireEagle::Location.new(location.to_s)
      end
      @best_guess = @locations.select { |location| location.best_guess? }.first
    end

  end
end