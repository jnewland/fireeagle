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
      @token = mock(OAuth::Token)
      OAuth::Token.should_receive(:new).and_return(@token)
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
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
      client.request_token_url.should =~ /\?oauth_token=foo/
    end
    
    it "should require #request_token_url be called before #convert_to_access_token" do
      lambda do
        client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
        client.convert_to_access_token
      end.should raise_error(FireEagle::ArgumentError)
    end
    
    it "should generate a Request Token URL" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret')
      @token = mock("token", :token => 'foo')
      client.stub!(:get).and_return('')
      client.stub!(:create_token).and_return(@token)
      client.request_token_url
      client.convert_to_access_token
      client.access_token.should == @token
    end
    
  end
  
  describe "xml parsing" do
    it "should raise an exception when returned xml with a status of fail" do
      client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      lambda do
        doc = Hpricot(XML_ERROR_RESPONSE)
        client.__send__(:parse_response, doc)
      end.should raise_error(FireEagle::FireEagleException)
    end
  end

  describe "updating" do

    before(:each) do
      @client = FireEagle::Client.new(:consumer_key => 'key', :consumer_secret => 'sekret', :access_token => 'toke', :access_token_secret => 'sekret')
      @response = mock('response', :body => XML_LOCATION_RESPONSE)
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

  end

end