module FireEagle
  class Locations
    include Enumerable
    include HappyMapper

    tag "locations"
    attribute :count, Integer
    attribute :start, Integer
    attribute :total, Integer
    has_many  :locations, Location, :single => false

    def [](*args)
      locations[*args]
    end

    alias_method :slice, :[]

    def each(&block)
      locations.each(&block)
    end

    def first
      locations.first
    end

    def last
      locations.last
    end

    def length
      locations.length
    end

    alias_method :size, :length
  end
end