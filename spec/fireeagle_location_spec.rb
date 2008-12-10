require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FireEagle Location" do

  before(:each) do
    @location = FireEagle::Location.parse(XML_LOCATION_CHUNK)
    @location_with_query = FireEagle::Location.parse(XML_QUERY_LOCATION_CHUNK)
  end

  it "should know if this is a best guess" do
    @location.should_not be_best_guess
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

  it "should use the name for #to_s" do
    @location.to_s.should == @location.name
  end

  it "should return the actual query string" do
    @location_with_query.query.should == "333 W Harbor Dr, San Diego, CA"
  end

  describe "GeoRuby support" do

    it "should represent a bounding box as a GeoRuby Envelope" do
      location = Hpricot.XML(XML_LOCATION_CHUNK)
      @location = FireEagle::Location.new(location)
      @location.geom.should be_an_instance_of(GeoRuby::SimpleFeatures::Envelope)
    end

    it "should represent an exact point as a GeoRuby Point" do
      location = Hpricot.XML(XML_EXACT_LOCATION_CHUNK)
      @location = FireEagle::Location.new(location)
      @location.geom.should be_an_instance_of(GeoRuby::SimpleFeatures::Point)
    end

    it "should be aliased as 'geo'" do
      location = Hpricot.XML(XML_EXACT_LOCATION_CHUNK)
      @location = FireEagle::Location.new(location)
      @location.geo.should be_an_instance_of(GeoRuby::SimpleFeatures::Point)
    end

  end

end
