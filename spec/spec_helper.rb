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

XML_LOCATION_CHUNK = <<-RESPONSE
<location best-guess="false" xmlns:georss="http://www.georss.org/georss">
  <georss:box>38.5351715088 -121.7948684692 38.575668335 -121.6747894287</georss:box>
  <level>3</level>
  <level-name>city</level-name>
  <located-at>2008-01-22T14:23:11-08:00</located-at>
  <name>Davis, CA</name>
  <place-id>u4L9ZOObApTdx1q3</place-id>
</location>
RESPONSE

XML_QUERY_LOCATION_CHUNK = <<-RESPONSE
<location best-guess="true" xmlns:georss="http://www.georss.org/georss">
  <id>111541</id>
  <georss:point>32.7093315125 -117.1650772095</georss:point>
  <level>0</level>
  <level-name>exact</level-name>
  <located-at>2008-03-03T09:05:16-08:00</located-at>
  <name>333 W Harbor Dr, San Diego, CA</name>
  <query> "q=333%20W%20Harbor%20Dr,%20San%20Diego,%20CA" </query>
</location>
RESPONSE


XML_EXACT_LOCATION_CHUNK = <<-RESPONSE
<location xmlns:georss="http://www.georss.org/georss">
  <georss:point>38.5351715088 -121.7948684692</georss:box>
</location>
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
