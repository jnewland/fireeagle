module FireEagle
  class StringWithExactMatch < String
    attr_writer :exact_match

    def initialize(value = "")
      node = XML::Parser.string(value).parse.root
      str = super(node.content)
      str.exact_match = node.attributes.to_h["exact-match"] == "true"
      node = nil

      str
    end

    def exact_match?
      @exact_match
    end
  end

  # Represents a location
  class Location
    include HappyMapper

    tag "location"
    attribute :best_guess, Boolean, :tag => "best-guess"
    element :label, String
    element :level, Integer
    element :level_name, String, :tag => "level-name"
    element :located_at, Time,   :tag => "located-at"
    element :name, String
    element :normal_name, String, :tag => "normal-name"
    element :place_id, StringWithExactMatch, :tag => "place-id", :parser => :new, :raw => true
    element :query, String
    element :woeid, StringWithExactMatch,    :parser => :new,    :raw => true

    element :_box, GeoRuby::SimpleFeatures::Geometry,   :tag => "box",
      :namespace => "georss", :parser => :from_georss, :raw => true
    element :_point, GeoRuby::SimpleFeatures::Geometry, :tag => "point",
      :namespace => "georss", :parser => :from_georss, :raw => true

    def best_guess?
      best_guess == true
    end

    # The GeoRuby[http://georuby.rubyforge.org/] representation of this location
    def geom
      _point || _box
    end

    alias_method :geo, :geom

    def to_s
      name
    end
  end
end
