#Describes a location
module FireEagle
  class Location
    include HappyMapper

    tag "//location"
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

    # TODO these break lookup requests
    # element :_box, String,      :tag => "georss:box"
    # element :_point, String,    :tag => "georss:point"

    def self.parse(xml, opts = {})
      super(xml, { :single => true }.merge(opts))
    end

    def best_guess?
      best_guess == true
    end

    def to_s
      name
    end

    # #The coordinates of the lower corner of a bounding box surrounding this Location
    # def lower_corner
    #   @georss ||= @doc.at("/location//georss:box").innerText.split.map{ |l| l.to_f } rescue nil
    #   @lower_corner ||= @georss[0..1] rescue nil
    # end
    # 
    # # The actual query that the user used so that it can be geocoded by the
    # # consumer since the Yahoo! geocoder is a little flaky, especially when it
    # # comes to intersections etc.
    # #
    # # Turns something like this:
    # #
    # # <query> "q=333%20W%20Harbor%20Dr,%20San%20Diego,%20CA" </query>
    # # 
    # # into
    # #
    # # 333 W Harbor Dr, San Diego, CA
    # def query
    #   @query ||= CGI::unescape((@doc.at("/location/query").innerText).gsub('"', '').split('=')[1]).strip rescue nil
    # end
    # 
    # # The GeoRuby[http://georuby.rubyforge.org/] representation of this location
    # def geom
    #   if @doc.at("/location//georss:box")
    #     @geo ||= GeoRuby::SimpleFeatures::Geometry.from_georss(@doc.at("/location//georss:box").to_s)
    #   elsif @doc.at("/location//georss:point")
    #     @geo ||= GeoRuby::SimpleFeatures::Geometry.from_georss(@doc.at("/location//georss:point").to_s)
    #   else
    #     return nil
    #   end
    # end
    # alias_method :geo, :geom
  end
end
