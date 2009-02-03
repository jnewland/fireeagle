require File.dirname(__FILE__) + '/spec_helper.rb'

describe FireEagle::Location do

  before(:each) do
    @location = FireEagle::Location.parse(responses(:location_chunk))
    @location_with_query = FireEagle::Location.parse(responses(:location_chunk_with_query))
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

  it "should represent the raw name" do
    @location.normal_name.should == "Davis"
  end

  it "should represent the location's place id" do
    @location.place_id.should == 'u4L9ZOObApTdx1q3'
  end

  it "should represent whether the location's place id is an exact match" do
    @location.place_id.should be_an_exact_match
  end

  it "should represent the location's WOEID" do
    @location.woeid.should == "2389646"
  end

  it "should represent whether the location's WOEID is an exact match" do
    @location.woeid.should be_an_exact_match
  end

  it "should represent the location's timestamp" do
    @location.located_at.should == Time.parse("2008-01-22T14:23:11-08:00")
  end

  it "should represent the label" do
    @location.label.should == "Home of UC Davis"
  end

  it "should use the name for #to_s" do
    @location.to_s.should == @location.name
  end

  it "should represent the querystring" do
    @location_with_query.query.should == "q=333%20W%20Harbor%20Dr,%20San%20Diego,%20CA"
  end

  describe "GeoRuby support" do
    it "should represent a bounding box as a GeoRuby Envelope" do
      @location = FireEagle::Location.parse(responses(:location_chunk))
      @location.geom.should be_an_instance_of(GeoRuby::SimpleFeatures::Envelope)
    end

    it "should represent an exact point as a GeoRuby Point" do
      @location = FireEagle::Location.parse(responses(:exact_location_chunk))
      @location.geom.should be_an_instance_of(GeoRuby::SimpleFeatures::Point)
    end

    it "should be aliased as 'geo'" do
      @location = FireEagle::Location.parse(responses(:exact_location_chunk))
      @location.geo.should be_an_instance_of(GeoRuby::SimpleFeatures::Point)
    end
  end
end
