begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end
require 'time'

module ResponseHelper
  def responses(key)
    File.read(File.join(File.dirname(__FILE__), "responses", "#{key}.xml"))
  end
end

Spec::Runner.configure do |config|
  include ResponseHelper
end

XML_ERROR_RESPONSE = File.read(File.join(File.dirname(__FILE__), "responses", "error.xml"))
XML_LOCATION_RESPONSE = File.read(File.join(File.dirname(__FILE__), "responses", "user.xml"))

XML_SUCCESS_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="utf-8"?>
<rsp stat="ok">
  <user token="16w3z6ysudxt"/>
</rsp>
RESPONSE

XML_LOOKUP_RESPONSE = File.read(File.join(File.dirname(__FILE__), "responses", "lookup.xml"))

XML_FAIL_LOOKUP_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="utf-8"?>
<rsp stat="fail">
  <err msg="Place can't be identified." code="6"/>
</rsp>
RESPONSE

XML_WITHIN_RESPONSE = File.read(File.join(File.dirname(__FILE__), "responses", "within.xml"))

XML_RECENT_RESPONSE = File.read(File.join(File.dirname(__FILE__), "responses", "recent.xml"))

require File.dirname(__FILE__) + '/../lib/fireeagle'
