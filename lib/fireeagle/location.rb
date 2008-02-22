#Describes a location
class FireEagle
  class Location

    #Initialize a Location from an XML response
    def initialize(doc)
      doc = Hpricot(doc) unless doc.is_a?(Hpricot::Doc || Hpricot::Elem)
      @doc = doc
    end

    #Level of granularity for this Location
    def level
      @level ||= @doc.at("/location/level").innerText.to_i
    end

    #Name of the level of granularity for this Location
    def level_name
      @level_name ||= @doc.at("/location/level-name").innerText
    end

    #Human Name for this Location
    def name
      @name ||= @doc.at("/location/name").innerText
    end

    #Unique identifier for this place. Pro-tip: This is the same place_id used by Flickr.
    def place_id
      @place_id ||= @doc.at("/location/place-id").innerText
    end

    #The Time at which the User last updated in this Location
    def located_at
      @located_at ||= Time.parse(@doc.at("/location/located-at").innerText)
    end

    #The coordinates of the lower corner of a bounding box surrounding this Location
    def lower_corner
      @georss ||= @doc.at("/location//georss:box").innerText.split.map{ |l| l.to_f }
      @lower_corner ||= @georss[0..1]
    end

    #The coordinates of the upper corner of a bounding box surrounding this Location
    def upper_corner
      @georss ||= @doc.at("/location//georss:box").innerText.split.map{ |l| l.to_f }
      @upper_corner ||= @georss[2..3]
    end

    #Is this Location FireEagle's best guess?
    def best_guess?
      @best_guess ||= @doc.at("/location").attributes["best-guess"] == "true"
    end

  end
end