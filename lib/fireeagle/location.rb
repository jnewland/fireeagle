#Describes a location
module FireEagle
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
    element :place_id, String,    :tag => "place-id"
    element :query, String
    element :woeid, Integer

    element :_box, GeoRuby::SimpleFeatures::Geometry,   :tag => "box",
      :namespace => "georss", :parser => :from_georss, :raw => true
    element :_point, GeoRuby::SimpleFeatures::Geometry, :tag => "point",
      :namespace => "georss", :parser => :from_georss, :raw => true

    def best_guess?
      best_guess == true
    end

    def to_s
      name
    end

    # The GeoRuby[http://georuby.rubyforge.org/] representation of this location
    def geom
      _point || _box
    end

    alias_method :geo, :geom
  end
end
