module FireEagle
  class Locations
    include Enumerable
    include HappyMapper

    tag "/rsp/locations"
    attribute :count, Integer
    attribute :start, Integer
    attribute :total, Integer
    has_many  :locations, Location

    def each(&block)
      locations.each(&block)
    end

    def first
      locations.first
    end

    def length
      locations.length
    end

    alias_method :size, :length
  end
end