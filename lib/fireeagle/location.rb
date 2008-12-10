#Describes a location
module FireEagle
  class Location

    #Initialize a Location from an XML response
    def initialize(doc)
      doc = Hpricot(doc) unless doc.is_a?(Hpricot::Doc || Hpricot::Elem)
      @doc = doc
    end

    def label
      @label ||= @doc.at("/location/label").innerText rescue nil
    end

    #Level of granularity for this Location
    def level
      @level ||= @doc.at("/location/level").innerText.to_i rescue nil
    end

    #Name of the level of granularity for this Location
    def level_name
      @level_name ||= @doc.at("/location/level-name").innerText rescue nil
    end

    #Human Name for this Location
    def name
      @name ||= @doc.at("/location/name").innerText rescue nil
    end
    alias_method :to_s, :name

    #Unique identifier for this place. Pro-tip: This is the same place_id used by Flickr.
    def place_id
      @place_id ||= @doc.at("/location/place-id").innerText rescue nil
    end
    
    #Numeric unique identifier for this place.
    def woeid
      @woeid ||= @doc.at("/location/woeid").innerText rescue nil
    end

    #The Time at which the User last updated in this Location
    def located_at
      @located_at ||= Time.parse(@doc.at("/location/located-at").innerText) rescue nil
    end

    #The coordinates of the lower corner of a bounding box surrounding this Location
    def lower_corner
      @georss ||= @doc.at("/location//georss:box").innerText.split.map{ |l| l.to_f } rescue nil
      @lower_corner ||= @georss[0..1] rescue nil
    end

    # The actual query that the user used so that it can be geocoded by the
    # consumer since the Yahoo! geocoder is a little flaky, especially when it
    # comes to intersections etc.
    #
    # Turns something like this:
    #
    # <query> "q=333%20W%20Harbor%20Dr,%20San%20Diego,%20CA" </query>
    # 
    # into
    #
    # 333 W Harbor Dr, San Diego, CA
    def query
      @query ||= CGI::unescape((@doc.at("/location/query").innerText).gsub('"', '').split('=')[1]).strip rescue nil
    end

    # The GeoRuby[http://georuby.rubyforge.org/] representation of this location
    def geom
      if @doc.at("/location//georss:box")
        @geo ||= GeoRuby::SimpleFeatures::Geometry.from_georss(@doc.at("/location//georss:box").to_s)
      elsif @doc.at("/location//georss:point")
        @geo ||= GeoRuby::SimpleFeatures::Geometry.from_georss(@doc.at("/location//georss:point").to_s)
      else
        return nil
      end
    end
    alias_method :geo, :geom
    
    #Is this Location FireEagle's best guess?
    def best_guess?
      @best_guess ||= @doc.at("/location").attributes["best-guess"] == "true" rescue false
    end

  end
end
