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
  
  ATTRIBUTES.each { |attribute| attr_reader attribute }
  
  def initialize(options = {}, verify_attributes = true)
    if verify_attributes
      options.reject! { |key, value| !ATTRIBUTES.include?(key) }
    end
    
    options.each_pair { |key, value| instance_variable_set("@#{key.to_s.gsub(/:/,'')}", value) }
  end
  
  class << self
    def new_from_xml(doc)
      #build the massive hash needed for a location
      options = { }
      doc = doc.at("/resultset")
      options[:locale] = doc.at("locale").innerText
      # quick parse of the xml
      doc.at("result").containers.each do |attribute| 
        options[attribute.xpath.split("/")[-1].to_sym] = attribute.inner_text
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
  
end