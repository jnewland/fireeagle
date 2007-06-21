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
  
  xspecify "" do
    # @location = FireEagle::Location.new(location_details)
  end

end