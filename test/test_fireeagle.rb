require File.dirname(__FILE__) + '/test_helper.rb'

context "The FireEagle class" do
  
  setup do
    @f = FireEagle::Base.new(:token => "foo", :secret => "bar")
  end
  
  specify "should require a secret and a token" do
     lambda { FireEagle::Base.new }.should.raise(FireEagle::ArgumentError)
     lambda { FireEagle::Base.new(:token => "foo") }.should.raise(FireEagle::ArgumentError)
     lambda { FireEagle::Base.new(:secret => "bar") }.should.raise(FireEagle::ArgumentError)
     lambda { FireEagle::Base.new(:token => "foo", :secret => "bar") }.should.not.raise(FireEagle::ArgumentError) 
  end
  
  specify "should have token and secret readers" do
    @f.token.should.equal "foo"
    @f.secret.should.equal "bar"
  end
  
  specify "should contain FireEagle::Application class accessor" do
    @f.application.class.should.equal FireEagle::Application
  end
  
  specify "is able to stub itself (learning experience here)" do
    FireEagle::Base.stubs(:foo).returns("bar")
    FireEagle::Base.foo.should.equal "bar"
  end
  
end
