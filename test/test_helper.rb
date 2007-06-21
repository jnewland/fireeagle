%w[ test/unit rubygems test/spec mocha hpricot ].each { |f| 
  begin
    require f
  rescue LoadError
    abort "Unable to load required gem for test: #{f}"
  end
}

require File.dirname(__FILE__) + '/../lib/fireeagle'

class MockSuccess < Net::HTTPSuccess #:nodoc: all
  def initialize
  end
end
