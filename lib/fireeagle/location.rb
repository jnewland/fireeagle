#Describes a location
class FireEagle
  class Location

    DETAILS = :lat, :lon, :'place-id', :geom, :address, :mnc, :mcc, :lac, :cid, :postal, :city, :state, :country, :q,
              # not yet supported
              :'upcoming-venue-id', :'yahoo-local-id', :'plazes-id'

    attr_reader :details

    #Create an instance of FireEagle::Location. There are some specific requirements for combinations of elements in the <code>options</code> Hash:
    #
    #* Requires all or none of :lat, :long
    #* Requires all or none of :mnc, :mcc, :lac, :cid
    def initialize(options = {}, verify_attributes = true)
      # symbolize keys
      options.map do |k,v|
        options[k.to_sym] = v
      end

      if verify_attributes
        option = options.reject { |key, value| DETAILS.include?(key) }
        raise FireEagle::ArgumentError, "Requires all or none of :lat, :long" unless options.has_all_or_none_keys?(:lat, :long)
        raise FireEagle::ArgumentError, "Requires all or none of :mnc, :mcc, :lac, :cellid" unless options.has_all_or_none_keys?(:mnc, :mcc, :lac, :cid)
      end

      @details = options
    end

    #Create a new instance of FireEagle::Location from the XML returned from Yahoo!
    def self.new_from_xml(doc)
      #build the massive hash needed for a location
      options = { }
      doc = doc.at("/location")
      FireEagle::Location.new(options, false)
    end
  end
end