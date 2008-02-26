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

  describe "GeoRuby support" do

    it "should represent a bounding box as a GeoRuby Envelope" do
      location = Hpricot.XML(XML_LOCATION_CHUNK)
      @location = FireEagle::Location.new(location)
      @location.geom.class.should == GeoRuby::SimpleFeatures::Envelope
    end

    it "should represent an exact point as a GeoRuby Point" do
      location = Hpricot.XML(XML_EXACT_LOCATION_CHUNK)
      @location = FireEagle::Location.new(location)
      @location.geom.class.should == GeoRuby::SimpleFeatures::Point
    end

    it "should be aliased as 'geo'" do
      location = Hpricot.XML(XML_EXACT_LOCATION_CHUNK)
      @location = FireEagle::Location.new(location)
      @location.geo.class.should == GeoRuby::SimpleFeatures::Point     
    end

  end

end