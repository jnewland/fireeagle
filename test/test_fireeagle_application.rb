require File.dirname(__FILE__) + '/test_helper.rb'

context "The FireEagle::Application class" do
  
  setup do
    @f = FireEagle::Base.new(:token => "foo", :secret => "bar")
    @application = @f.application
    @response = MockSuccess.new
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
  end
  
  specify "should require a token for token exchange" do
    lambda { user = @application.exchange_token }.should.raise FireEagle::ArgumentError
  end
  
  specify "should return a FireEagle::User object when asked for a token exchange" do
    @response.expects(:body).returns(@token_response)
    Net::HTTP.expects(:get_response).returns(@response)    
    user = @application.exchange_token(1234)
    user.should.be.an.instance_of FireEagle::User
  end
  
  specify "should raise an Exception for a bad token" do
    @response.expects(:body).returns(@error_response)
    Net::HTTP.expects(:get_response).returns(@response)    
    lambda { user = @application.exchange_token(666) }.should.raise FireEagle::FireEagleException
  end
  
  specify "should provide a authorization url" do
    @application.authorize_url.should.equal "http://#{FireEagle::API_DOMAIN}/authorize.php?appid=foo&callback="
  end
  
  specify "should escape the callback url provided to authorize_url" do
    @application.authorize_url("one two").should.equal "http://#{FireEagle::API_DOMAIN}/authorize.php?appid=foo&callback=one+two"
  end
end