require File.dirname(__FILE__) + '/test_helper.rb'

context "The FireEagle::User class" do
  
  setup do
    @f = FireEagle::Base.new(:token => "foo", :secret => "bar")
    @error_response = <<-RESPONSE
    <ResultSet version="1.0">
    	<Error>1</Error>
    	<ErrorMessage>Something bad happened</ErrorMessage>
    </ResultSet>
    RESPONSE
    @token_response = <<-RESPONSE
    <rsp stat="ok">
    	<token>1234</token>
    </rsp>
    RESPONSE
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
    @update_response = <<-RESPONSE
    <ResultSet version="1.0">
    	<Error>0</Error>
    	<ErrorMessage>No error</ErrorMessage>
      </ResultSet>
    RESPONSE
    @response = MockSuccess.new
    @response.expects(:body).returns(@token_response)
    Net::HTTP.expects(:get_response).returns(@response)    
    @user = @f.application.exchange_token(1234)
  end

  specify "should have a token accessor" do
    @user.should.be.an.instance_of FireEagle::User
    @user.token.should.equal "1234"
  end
  
  specify "should be able to create a new user with a token" do
    @newuser = FireEagle::User.new(@f, 1234)
    @newuser.token.should.be.equal "1234"
  end
  
  
  specify "should return a FireEagle::Location class when asked for a location" do
    #get the location
    @response.expects(:body).returns(@location_response)
    Net::HTTP.expects(:get_response).returns(@response)
    @user.location.should.be.an.instance_of FireEagle::Location
  end
  
  
  specify "should be able to set a location" do
    #set the location
    @response.expects(:body).returns(@update_response)
    Net::HTTP.expects(:get_response).returns(@response)
    @l = FireEagle::Location.new(:country => "Belize")
    @set_location = (@user.location = @l)
    @set_location.should.be.an.instance_of FireEagle::Location
    @set_location.should.be.equal @l
  end
  
end