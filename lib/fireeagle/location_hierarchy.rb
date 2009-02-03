module FireEagle
  class LocationHierarchy
    include HappyMapper

    tag "location-hierarchy"
    attribute :string,    String
    attribute :timezone,  String
    has_many  :locations, Location
  end
end