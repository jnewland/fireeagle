require File.dirname(__FILE__) + '/test_helper.rb'

context "The FireEagle::Location class" do

  setup do
    @location_response = <<-RESPONSE
    <ResultSet version="1.0">
    	<Error>0</Error>
    	<ErrorMessage>No error</ErrorMessage>
    	<Locale>us_US</Locale>
    	<Quality>0</Quality>
    	<Found>1</Found>
    	<Result>
    		<updatetime> 2007-06-14T22:43:29Z</updatetime>
    		<quality>60</quality>
    		<latitude>37.872236</latitude>
    		<longitude>-122.244972</longitude>
    		<offsetlat>37.872238</offsetlat>
    		<offsetlon>-122.218628</offsetlon>
    		<radius>3200</radius>
    		<boundingbox>
    			<north>37.884701</north>
    			<south>37.859772</south>
    			<east>-122.216743</east>
    			<west>-122.273201</west>
    		</boundingbox>
    		<name/>
    		<line1/>
    		<line2>Berkeley, CA  94704</line2>
    		<line3/>
    		<line4>United States</line4>
    		<house/>
    		<street/>
    		<xstreet/>
    		<unittype/>
    		<unit/>
    		<postal>94704</postal>
    		<neighborhood/>
    		<city>Berkeley</city>
    		<county>Alameda County</county>
    		<state>California</state>
    		<country>United States</country>
    		<countrycode>US</countrycode>
    		<statecode>CA</statecode>
    		<countycode/>
    		<timezone>America/Los_Angeles</timezone>
    	</Result>
    </ResultSet>
    RESPONSE
    @error_response = <<-RESPONSE
    <ResultSet version="1.0">
    	<Error>1</Error>
    	<ErrorMessage>Something bad happened</ErrorMessage>
    </ResultSet>
    RESPONSE
  end
  
  specify "Requires all or none of :lat, :long" do
    lambda { FireEagle::Location.new(:lat => 1) }.should.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:lat => 1, :long => 2) }.should.not.raise FireEagle::ArgumentError
  end
  
  specify "Requires all or none of :mnc, :mcc, :lac, :cellid" do
    lambda { FireEagle::Location.new(:mcc => 123, :lac => "whatever", :cellid => true) }.should.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:mcc => 123, :mnc => 123123, :lac => "whatever", :cellid => true) }.should.not.raise FireEagle::ArgumentError
  end
  
  specify "Requires all or none of :street1, :street2" do
    lambda { FireEagle::Location.new(:street1 => "easy street") }.should.raise FireEagle::ArgumentError
  end
  
  specify "Requires :postal or :city with :street1 and :street2" do
    lambda { FireEagle::Location.new(:street1 => "easy street", :street2 => "lazy lane") }.should.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:street1 => "easy street", :street2 => "lazy lane", :city => "anytown", :country => "US") }.should.not.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:street1 => "easy street", :street2 => "lazy lane", :postal => 12345) }.should.not.raise FireEagle::ArgumentError
  end
  
  specify "Requires :city or :postal with :addr" do
    lambda { FireEagle::Location.new(:addr => "1 easy street") }.should.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:addr => "1 easy street", :city => "anytown", :country => "US") }.should.not.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:addr => "1 easy street", :postal => 12345) }.should.not.raise FireEagle::ArgumentError
  end
  
  specify "Requires :state, :country, or :postal with :city" do
    lambda { FireEagle::Location.new(:city => "armuchee") }.should.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:city => "armuchee", :state => "GA") }.should.not.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:city => "armuchee", :postal => 12345) }.should.not.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:city => "armuchee", :country => "US") }.should.not.raise FireEagle::ArgumentError
  end
  
  specify "Requires :country with :postal if not in US" do
    lambda { FireEagle::Location.new(:postal => "a49", :country => "Armenia") }.should.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:postal => 30605, :country => "US") }.should.not.raise FireEagle::ArgumentError
    lambda { FireEagle::Location.new(:postal => 30605) }.should.not.raise FireEagle::ArgumentError
  end
    
end