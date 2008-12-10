module FireEagle
  class LocationHierarchy
    include HappyMapper

    tag "/rsp/user/location-hierarchy"
    attribute :timezone, String
    has_many  :locations, Location
  end
end