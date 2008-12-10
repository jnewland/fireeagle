module FireEagle
  class User
    include HappyMapper

    tag "/rsp//user"
    attribute :located_at, Time, :tag => "located-at"
    attribute :readable, Boolean
    attribute :token, String
    attribute :writable, Boolean
    has_one   :location_hierarchy, LocationHierarchy, :tag => "location-hierarchy"

    def best_guess
      @best_guess ||= locations.select { |loc| loc.best_guess? }.first
    end

    def locations
      location_hierarchy && location_hierarchy.locations
    end
  end
end