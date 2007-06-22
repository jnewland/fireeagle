#Describes a location
class FireEagle::Location
  
  DETAILS = :locale, :quality, :updatetime, :latitute, :longitude, :offsetlat, :offsetlon, 
              :radius, :boundinglatnorth, :boundinglatsouth, :boundinglateast, :boundinglatwest,
              :name, :line1, :line2, :line3, :line4, :house, :street, :xstreet, :unittype, :unit,
              :neighborhood, :city, :county, :state, :country, :coutrycode, :statecode, :countrycode,
              :timezone, 
              # attributes used only on update
              :source, :addr, :mcn, :mcc, :lac, :cellid, :loc, :name, :woeid, :plazesid, 
              :upvenueid, :street1, :street2
  
  attr_reader :details
  
  #Create an instance of FireEagle::Location. There are some specific requirements for combinations of elements in the <code>options</code> Hash:
  #
  #* Requires all or none of :lat, :long
  #* Requires all or none of :mnc, :mcc, :lac, :cellid
  #* Requires all or none of :street1, :street2
  #* Requires :postal or :city with :street1 and :street2
  #* Requires :city or :postal with :addr
  #* Requires :state, :country, or :postal with :city
  #* Requires :country with :postal if not in US
  def initialize(options = {}, verify_attributes = true)
    option = options.reject { |key, value| DETAILS.include?(key) }
    
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
    #Create a new instance of FireEagle::Location from the XML returned from Yahoo!
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