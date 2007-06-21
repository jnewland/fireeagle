# Locale     String    Locale code
# Quality   Integer   quality of the input address
# Result.UpdateTime   Date  W3C format time of the most recent location update from which response location is generated (UTC time)
# Result.Quality  Integer   Quality of the result (geocoding quality, not necessarily precision)
# Result.Latitude   Float   Latitude of matched point in degrees
# Result.Longitude  Float   Longitude of matched point in degrees
# Result.OffsetLat  Float   Latitude of offset point in degrees
# Result.OffsetLon  Float   Longitude of offset point in degrees
# Result.Radius   Integer   Radius of matched area in meters
# Result.BoundingBox  Container   Bounding box
# Result.Name   String  POI/AOI name or Airport code
# Result.Line1  String  First line of address (House Street UnitType Unit)
# Result.Line2  String  Second line of address (City State Zip in the US)
# Result.Line3  String  Third line of address
# Result.House  String  House number
# Result.Street   String/Container  Street name or container for detailed street data
# Result.XStreet  String/Container  Cross street name or container for detailed street data (if S flag is set)
# Result.UnitType   String  Unit type
# Result.Unit   String  Unit/Suite/Apartment/Box
# Result.Postal   String  Postal code
# Result.Neighborhood   String  Neighborhood name
# Result.City   String  City name
# Result.County   String  County name (US/Canada only)
# Result.State  String  State/Province name
# Result.Country  String  Country name
# Result.CountyCode   String  County 3166-2 code
# Result.StateCode  String  State 3166-2 code
# Result.CountryCode  String  Country 3166-1 code
# Result.Timezone   String  Timezone tz name
class FireEagle::Location
  
  ATTRIBUTES = :locale, :quality, :updatetime, :latitute, :longitude, :offsetlat, :offsetlon, 
              :radius, :boundinglatnorth, :boundinglatsouth, :boundinglateast, :boundinglatwest,
              :name, :line1, :line2, :line3, :line4, :house, :street, :xstreet, :unittype, :unit,
              :neighborhood, :city, :county, :state, :country, :coutrycode, :statecode, :countrycode,
              :timezone, 
              # attributes used only on update
              :source, :addr, :mcn, :mcc, :lac, :cellid, :loc, :name, :woeid, :plazesid, 
              :upvenueid, :street1, :street2
  
  attr_reader :details
  
  def initialize(options = {}, verify_attributes = true)
    option = options.reject { |key, value| ATTRIBUTES.include?(key) }
    
    if verify_attributes
      raise FireEagle::ArgumentError, "Requires all or none of :lat, :long" unless options.has_all_or_none_keys?(:lat, :long)
      raise FireEagle::ArgumentError, "Requires all or none of :mnc, :mcc, :lac, :cellid" unless options.has_all_or_none_keys?(:mnc, :mcc, :lac, :cellid)
      raise FireEagle::ArgumentError, "Requires all or none of :street1, :street2" unless options.has_all_or_none_keys?(:street1, :street2)
      raise FireEagle::ArgumentError, "Requires :postal or :city with :street1 and :street2" if (options.has_key?(:street1) and options.has_key?(:street2)) and !(options.has_key?(:city) or options.has_key?(:postal))
      raise FireEagle::ArgumentError, "Requires :city or :postal with :addr" if options.has_key?(:addr) and !(options.has_key?(:city) or options.has_key?(:postal))
      raise FireEagle::ArgumentError, "Requires :state, :country, or :postal with :city" if options.has_key?(:city) and !(options.has_key?(:state) or options.has_key?(:country) or options.has_key?(:postal))
      raise FireEagle::ArgumentError, "Requires :country with :postal if not in US" if (options.has_key?(:postal) and options.has_key?(:country)) and (options[:country] != "US")
    end
    
    @details = options
  end
  
  class << self
    def new_from_xml(doc)
      #build the massive hash needed for a location
      options = { }
      doc = doc.at("/resultset")
      options[:locale] = doc.at("locale").innerText unless doc.at("locale").nil?
      # quick parse of the xml
      puts doc if FireEagle::DEBUG
      doc.at("result").containers.each do |attribute| 
        options[attribute.xpath.split("/")[-1].to_sym] = attribute.inner_text unless attribute.nil?
      end
      #fixup types
      options[:updatetime] = Time.parse(options[:updatetime])
      options[:radius] = options[:radius].to_i
      options[:quality] = options[:radius].to_i
      %w(latitude longitude offsetlat offsetlon :boundinglatnorth boundinglatsouth boundinglateast boundinglatwest).each do |attribute|
        options[attribute.to_sym].nil? || options[attribute.to_sym].empty? ? (options[attribute.to_sym] = '') : (options[attribute.to_sym] = options[attribute.to_sym].to_f)
      end
      
      FireEagle::Location.new(options, false)
    end
  end

private
  
  def verify_attribute_combination(options, *args)
    args.each do |a|
      return false unless options.include?(a)
    end
    return true
  end
  
  
end