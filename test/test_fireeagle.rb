require File.dirname(__FILE__) + '/test_helper.rb'

context "The FireEagle class" do
  
  setup do
    @f = FireEagle.new(:token => "foo", :secret => "bar")
  end
  
  specify "should require a secret and a token" do
     lambda { FireEagle.new }.should.raise(FireEagle::ArgumentError)
     lambda { FireEagle.new(:token => "foo") }.should.raise(FireEagle::ArgumentError)
     lambda { FireEagle.new(:secret => "bar") }.should.raise(FireEagle::ArgumentError)
     lambda { FireEagle.new(:token => "foo", :secret => "bar") }.should.not.raise(FireEagle::ArgumentError) 
  end
  
  specify "should have token and secret readers" do
    @f.token.should.equal "foo"
    @f.secret.should.equal "bar"
  end
  
  specify "should contain FireEagle::Application class accessor" do
    @f.application.class.should.equal FireEagle::Application
  end
  
  xspecify "signs and encodes parameters sent to request" do
  end
  
  specify "is able to stub itself (learning experience here)" do
    FireEagle.stubs(:foo).returns("bar")
    FireEagle.foo.should.equal "bar"
  end
  
end
