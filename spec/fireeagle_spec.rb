require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FireEagle" do

  describe "being initialized" do

    it "should require OAuth Consumer Key and Secret" do
      lambda do
        client = FireEagle::Client.new({})
      end.should raise_error(FireEagle::ArgumentError)
    end

    it "should initialize an OAuth::Consumer" do
      @consumer = mock(OAuth::Consumer)
      OAuth::Consumer.should_receive(:new).with('key', 'sekret', :site => FireEagle::API_SERVER, :authorize_url => FireEagle::AUTHORIZATION_URL).and_return(@consumer)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
    end

  end

  describe "web app authentication scenario" do

    it "should initialize an OAuth::AccessToken if given its token and secret" do
      @access_token = mock(OAuth::AccessToken)
      OAuth::AccessToken.stub!(:new).and_return(@access_token)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      client.access_token.should == @access_token
    end

    it "should initialize an OAuth::RequestToken if given its token and secret" do
      @request_token = mock(OAuth::RequestToken)
      OAuth::RequestToken.stub!(:new).and_return(@request_token)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :request_token => 'toke', :request_token_secret => 'sekret')
      client.request_token.should == @request_token
    end
  end

  describe "request token scenario" do
    it "shouldn't initialize with a access_token" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      client.access_token.should be_nil
    end

    it "should require token exchange before calling any API methods" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      lambda do
        client.user
      end.should raise_error(FireEagle::ArgumentError)
    end

    it "should generate a Request Token URL" do
      consumer = mock(OAuth::Consumer)
      token    = mock(OAuth::RequestToken)
      consumer.should_receive(:get_request_token).and_return(token)
      token.should_receive(:authorize_url)

      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      client.should_receive(:consumer).and_return(consumer)
      client.get_request_token
      client.authorization_url
    end

    it "should require #get_request_token be called before #convert_to_access_token" do
      lambda do
        client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
        client.convert_to_access_token
      end.should raise_error(FireEagle::ArgumentError)
    end

    it "should require #get_request_token be called before #authorization_url" do
      lambda do
        client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
        client.authorization_url
      end.should raise_error(FireEagle::ArgumentError)
    end

    it "should generate an Access Token" do
      consumer  = mock(OAuth::Consumer)
      req_token = mock(OAuth::RequestToken)
      acc_token = mock(OAuth::AccessToken)
      consumer.should_receive(:get_request_token).and_return(req_token)
      req_token.should_receive(:get_access_token).and_return(acc_token)

      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      client.should_receive(:consumer).and_return(consumer)

      client.get_request_token
      client.convert_to_access_token
      client.access_token.should == acc_token
    end

  end

  describe "update method" do

    before(:each) do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = stub('response', :body => XML_SUCCESS_RESPONSE)
      @client.stub!(:request).and_return(@response)
    end

    it "requires all or none of :lat, :lon" do
      lambda { @client.update(:lat => 1) }.should raise_error(FireEagle::ArgumentError)
      lambda { @client.update(:lat => 1, :lon => 2) }.should_not raise_error(FireEagle::ArgumentError)
    end

    it "requires all or none of :mnc, :mcc, :lac, :cellid" do
      lambda { @client.update(:mcc => 123, :lac => "whatever", :cellid => true) }.should raise_error(FireEagle::ArgumentError)
      lambda { @client.update(:mcc => 123, :mnc => 123123, :lac => "whatever", :cellid => true) }.should_not raise_error(FireEagle::ArgumentError)
    end

    it "should wrap the result" do
      @client.update(:mcc => 123, :mnc => 123123, :lac => "whatever", :cellid => true).users.first.token.should == "16w3z6ysudxt"
    end

  end

  describe "user method" do

    before(:each) do
      @client   = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      response = stub('response', :body => XML_LOCATION_RESPONSE)
      @client.stub!(:request).and_return(response)
    end

    it "should return a best guess" do
      @client.user.best_guess.name.should == "Yolo County, California"
    end

    it "should return several locations" do
      @client.user.should have(4).locations
    end

  end

  describe "lookup method" do
    before(:each) do
      @client       = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      response      = stub('response', :body => XML_LOOKUP_RESPONSE)
      fail_response = stub('fail response', :body => XML_FAIL_LOOKUP_RESPONSE)
      @client.stub!(:request).with(:get, FireEagle::LOOKUP_API_PATH, :params => {:q => "30022"}).and_return(response)
      @client.stub!(:request).with(:get, FireEagle::LOOKUP_API_PATH, :params => {:mnc => 12, :mcc => 502, :lac => 2051, :cellid => 39091}).and_return(fail_response)
    end

    it "should return an array of Locations" do
      @client.lookup(:q => "30022").should have(9).items
    end

    it "should return a place id for each" do
      @client.lookup(:q => "30022").first.place_id.should == "IrhZMHuYA5s1fFi4Qw"
    end

    it "should return a name for each" do
      @client.lookup(:q => "30022").first.name.should == "Alpharetta, GA 30022"
    end

    it "should raise an exception if the lookup failed" do
      lambda {
        @client.lookup(:mnc => 12, :mcc => 502, :lac => 2051, :cellid => 39091)
      }.should raise_error(FireEagle::FireEagleException, "Place can't be identified.")
    end
  end

  describe "within method" do
    before do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = stub('response', :body => XML_WITHIN_RESPONSE)
      @client.stub!(:request).and_return(@response)
    end

    it "should return an array of Users" do
      @client.within(:woe => "12796255").should have(2).users
    end
  end

  describe "recent method" do
    before do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = stub('response', :body => XML_RECENT_RESPONSE)
      @client.stub!(:request).and_return(@response)
    end

    it "should return an array of Users" do
      @client.recent('yesterday', 3, 1).should have(3).users
    end

    it "should have an 'located_at' timestamp for each user" do
      @client.recent('yesterday', 3, 1).first.located_at.should == Time.parse('2008-07-31T22:31:37+12:00')
    end
  end

  describe "making a request" do
    before do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @access_token = stub('access token')
      @client.stub!(:access_token).and_return(@access_token)
    end

    it "should not raise any exception when response is OK" do
      response = stub('response', :code => '200', :body => XML_RECENT_RESPONSE)
      @access_token.stub!(:request).and_return(response)
      lambda { @client.recent }.should_not raise_error
    end

    it "should raise an exception when requesting to a resource that doesn't exist (404)" do
      response = stub('response', :code => '404', :body => '')
      @access_token.stub!(:request).and_return(response)
      lambda { @client.recent }.should raise_error(FireEagle::FireEagleException, 'Not Found')
    end

    it "should raise an exception when requesting to a resource that hit an internal server error (500)" do
      response = stub('response', :code => '500', :body => '')
      @access_token.stub!(:request).and_return(response)
      lambda { @client.recent }.should raise_error(FireEagle::FireEagleException, 'Internal Server Error')
    end

    it "should raise an exception when response is apart from 200, 404 and 500" do
      %w{401 403 405}.each do |code|
        response = stub('response', :code => code, :body => XML_ERROR_RESPONSE)
        @access_token.stub!(:request).and_return(response)
        lambda { @client.recent }.should raise_error(FireEagle::FireEagleException, 'Something bad happened')
      end
    end
  end
end
