require File.dirname(__FILE__) + '/spec_helper.rb'

describe "FireEagle Location" do
  it "Requires all or none of :lat, :long" do
    lambda { FireEagle::Location.new(:lat => 1) }.should raise_error(FireEagle::ArgumentError)
    lambda { FireEagle::Location.new(:lat => 1, :long => 2) }.should_not raise_error(FireEagle::ArgumentError)
  end
  
  it "Requires all or none of :mnc, :mcc, :lac, :cid" do
    lambda { FireEagle::Location.new(:mcc => 123, :lac => "whatever", :cid => true) }.should raise_error(FireEagle::ArgumentError)
    lambda { FireEagle::Location.new(:mcc => 123, :mnc => 123123, :lac => "whatever", :cid => true) }.should_not raise_error(FireEagle::ArgumentError)
  end
  
  # removed
  # it "Requires all or none of :street1, :street2" do
  #   lambda { FireEagle::Location.new(:street1 => "easy street") }.should.raise FireEagle::ArgumentError
  # end
  # 
  # it "Requires :postal or :city with :street1 and :street2" do
  #   lambda { FireEagle::Location.new(:street1 => "easy street", :street2 => "lazy lane") }.should.raise FireEagle::ArgumentError
  #   lambda { FireEagle::Location.new(:street1 => "easy street", :street2 => "lazy lane", :city => "anytown", :country => "US") }.should.not.raise FireEagle::ArgumentError
  #   lambda { FireEagle::Location.new(:street1 => "easy street", :street2 => "lazy lane", :postal => 12345) }.should.not.raise FireEagle::ArgumentError
  # end
end