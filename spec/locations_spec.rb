require File.dirname(__FILE__) + '/spec_helper.rb'

describe FireEagle::Locations do
  before :each do
    @instance = FireEagle::Locations.parse(responses(:locations_chunk))
  end

  it "should be Enumerable" do
    @instance.should be_a_kind_of(Enumerable)
  end

  it "should have a length" do
    @instance.length.should == 9
  end

  it "should have a size" do
    @instance.size.should == 9
  end

  it "should be indexable" do
    @instance[0].should_not be_nil
  end

  it "should be indexable by Range" do
    @instance[0..2].length.should == 3
  end

  it "should be indexable by 'start' and 'length'" do
    @instance[0, 2].length.should == 2
  end

  it "should be sliceable" do
    @instance.should respond_to(:slice)
  end

  it "should have a first element" do
    @instance.first.should == @instance[0]
  end

  it "should have a last element" do
    @instance.last.should == @instance[-1]
  end
end
