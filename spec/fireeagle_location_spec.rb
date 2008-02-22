require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FireEagle Location" do

  before(:each) do
    location = Hpricot.XML(XML_LOCATION_CHUNK)
    @location = FireEagle::Location.new(location)
  end

  it "should know if this is a best guess" do
    @location.best_guess?.should == false
  end

  it "should represent the level" do
    @location.level.should == 3
  end

  it "should represent the level name" do
    @location.level_name.should == 'city'
  end

  it "should represent the location name" do
    @location.name.should == 'Davis, CA'
  end

  it "should represent the location place id" do
    @location.place_id.should == 'u4L9ZOObApTdx1q3'
  end

  it "should represent the location's timestamp" do
    @location.located_at.should == Time.parse("2008-01-22T14:23:11-08:00")
  end

  it "should represent the location's bounding box" do
    @location.lower_corner.should == [38.5351715088, -121.7948684692]
    @location.upper_corner.should == [38.575668335, -121.6747894287]
  end

end