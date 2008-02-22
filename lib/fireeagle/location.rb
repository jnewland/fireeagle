#Describes a location
class FireEagle
  class Location

    attr_reader :level, :level_name, :name, :place_id, :located_at, :lower_corner, :upper_corner

    #Create an instance of FireEagle::Location from an XML response
    def initialize(doc)
      doc = Hpricot(doc) unless doc.is_a?(Hpricot::Doc || Hpricot::Elem)
      @best_guess = doc.at("/location").attributes["best-guess"] == "true"
      @level = doc.at("/location/level").innerText.to_i
      @level_name = doc.at("/location/level-name").innerText
      @name = doc.at("/location/name").innerText
      @place_id = doc.at("/location/place-id").innerText
      @located_at = Time.parse(doc.at("/location/located-at").innerText)
      georss = doc.at("/location//georss:box").innerText.split.map{ |l| l.to_f }
      @lower_corner = georss[0..1]
      @upper_corner = georss[2..3]
    end

    #is this location FireEagle's best guess?
    def best_guess?
      @best_guess
    end

  end
end