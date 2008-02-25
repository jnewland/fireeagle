require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FireEagle Response" do

  describe "user / location parsing" do

    before(:each) do
      @response = FireEagle::Response.new(XML_LOCATION_RESPONSE)
    end
    
    it "should indicate success" do
      @response.success?.should == true
    end

    it "should have an array of users" do
      @response.users.size.should == 1
    end
    
    it "should have each users' token" do
      @response.users.first.token.should == "16w3z6ysudxt"
    end
    
    it "should flag the best guess" do
      @response.users.first.best_guess.name.should == "Yolo County, California"
    end
    
    it "should have users' loactions" do
      @response.users.first.locations.size.should == 4
    end

  end
  
  describe "location parsing" do

    before(:each) do
      @response = FireEagle::Response.new(XML_LOOKUP_RESPONSE)
    end

    it "should indicate success" do
      @response.success?.should == true
    end

    it "should have an array of locations" do
      @response.locations.size.should == 9
    end

    it "should have each location's place_id" do
      @response.locations.first.place_id.should == "IrhZMHuYA5s1fFi4Qw"
    end

    it "should have each location's name" do
      @response.locations.first.name.should == "Alpharetta, GA 30022"
    end

  end

  describe "error handling" do

    it "should raise an exception when returned xml with a status of fail" do
      lambda { FireEagle::Response.new(XML_ERROR_RESPONSE) }.should raise_error(FireEagle::FireEagleException)
    end

  end

end