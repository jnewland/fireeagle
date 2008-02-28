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
      OAuth::Consumer.should_receive(:new).and_return(@consumer)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
    end

  end

  describe "web app authentication scenario" do

    it "should initialize a OAuth::Token if given it's token and secret" do
      @access_token = mock(OAuth::Token)
      OAuth::Token.stub!(:new).and_return(@access_token)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      client.access_token.should == @access_token
    end

    it "should initialize a request token if given one" do
      @request_token = mock(OAuth::Token)
      OAuth::Token.stub!(:new).and_return(@request_token)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :request_token => 'toke', :request_token_secret => 'sekret')
      client.request_token.should == @request_token
    end
  end

  describe "request token scenario" do
    it "shouldn't initialize with a access_token" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      client.access_token.should == nil
    end

    it "should require token exchange before calling any API methods" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      lambda do
        client.user
      end.should raise_error(FireEagle::ArgumentError)
    end

    it "should generate a Request Token URL" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      @token = mock("token", :token => 'foo')
      client.stub!(:get).and_return('')
      client.stub!(:create_token).and_return(@token)
      client.get_request_token
      client.authorization_url.should =~ /\?oauth_token=foo/
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

    it "should generate a Request Token URL" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      @token = mock("token", :token => 'foo')
      client.stub!(:get).and_return('')
      client.stub!(:create_token).and_return(@token)
      client.get_request_token
      client.convert_to_access_token
      client.access_token.should == @token
    end

  end

  describe "update method" do

    before(:each) do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = mock('response', :body => XML_SUCCESS_RESPONSE)
      @client.stub!(:request).and_return(@response)
    end

    it "requires all or none of :lat, :lon" do
      lambda { @client.update(:lat => 1) }.should raise_error(FireEagle::ArgumentError)
      lambda { @client.update(:lat => 1, :lon => 2) }.should_not raise_error(FireEagle::ArgumentError)
    end

    it "requires all or none of :mnc, :mcc, :lac, :cid" do
      lambda { @client.update(:mcc => 123, :lac => "whatever", :cid => true) }.should raise_error(FireEagle::ArgumentError)
      lambda { @client.update(:mcc => 123, :mnc => 123123, :lac => "whatever", :cid => true) }.should_not raise_error(FireEagle::ArgumentError)
    end

    it "should wrap the result" do
      @client.update(:mcc => 123, :mnc => 123123, :lac => "whatever", :cid => true).users.first.token.should == "16w3z6ysudxt"
    end

  end

  describe "user method" do

    before(:each) do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = mock('response', :body => XML_LOCATION_RESPONSE)
      @client.stub!(:request).and_return(@response)
    end

    it "should return a best guess" do
      @client.user.best_guess.name.should == "Yolo County, California"
    end

    it "should return several locations" do
      @client.user.locations.size.should == 4
    end

  end
  
  describe "lookup method" do

    before(:each) do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = mock('response', :body => XML_LOOKUP_RESPONSE)
      @client.stub!(:request).and_return(@response)
    end

    it "should return an array of Locations" do
      @client.lookup(:q => "30022").size.should == 9
    end

    it "should return a place id for each" do
      @client.lookup(:q => "30022").first.place_id.should == "IrhZMHuYA5s1fFi4Qw"
    end

    it "should return a name for each" do
      @client.lookup(:q => "30022").first.name.should == "Alpharetta, GA 30022"
    end

  end

end