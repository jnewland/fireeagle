begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

XML_ERROR_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="utf-8"?>
<rsp stat="fail">
  <err code="11" msg="Something bad happened" />
</rsp>
RESPONSE

XML_LOCATION_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="utf-8"?>
<rsp stat="ok" xmlns:georss="http://www.georss.org/georss">
  <user token="16w3z6ysudxt">
    <location-hierarchy>
      <location best-guess="false">
        <georss:box>38.5351715088 -121.7948684692 38.575668335 -121.6747894287</georss:box>
        <level>3</level>
        <level-name>city</level-name>
        <located-at>2008-01-22T14:23:11-08:00</located-at>
        <name>Davis, CA</name>
        <place-id>u4L9ZOObApTdx1q3</place-id>
      </location>
      <location best-guess="true">
        <georss:box>38.3131217957 -122.4230804443 38.9261016846 -121.5012969971</georss:box>
        <level>4</level>
        <level-name>region</level-name>
        <located-at>2008-01-22T18:45:26-08:00</located-at>
        <name>Yolo County, California</name>
        <place-id>YUYMh9CbBJ61mgFe</place-id>
      </location>
      <location best-guess="false">
        <georss:box>32.5342788696 -124.4150238037 42.0093803406 -114.1308135986</georss:box>
        <level>5</level>
        <level-name>state</level-name>
        <located-at>2008-01-22T18:45:26-08:00</located-at>
        <name>California</name>
        <place-id>SVrAMtCbAphCLAtP</place-id>
      </location>
      <location best-guess="false">
        <georss:box>18.9108390808 -167.2764129639 72.8960571289 -66.6879425049</georss:box>
        <level>6</level>
        <level-name>country</level-name>
        <located-at>2008-01-22T18:45:26-08:00</located-at>
        <name>United States</name>
        <place-id>4KO02SibApitvSBieQ</place-id>
      </location>
    </location-hierarchy>
  </user>
</rsp>
RESPONSE

XML_SUCCESS_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="utf-8"?>
<rsp stat="ok">
  <user token="16w3z6ysudxt"/>
</rsp>
RESPONSE

XML_LOCATION_CHUNK = <<-RESPONSE
<location best-guess="false">
  <georss:box>38.5351715088 -121.7948684692 38.575668335 -121.6747894287</georss:box>
  <level>3</level>
  <level-name>city</level-name>
  <located-at>2008-01-22T14:23:11-08:00</located-at>
  <name>Davis, CA</name>
  <place-id>u4L9ZOObApTdx1q3</place-id>
</location>
RESPONSE

XML_EXACT_LOCATION_CHUNK = <<-RESPONSE
<location>
  <georss:point>38.5351715088 -121.7948684692</georss:box>
</location>
RESPONSE

XML_LOOKUP_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="ok">
  <querystring>q=30022</querystring>
  <locations start="0" total="9" count="9">
    <location>
      <name>Alpharetta, GA 30022</name>
      <place-id>IrhZMHuYA5s1fFi4Qw</place-id>
    </location>
    <location>
      <name>Hannover, Region Hannover, Deutschland</name>
      <place-id>88Hctc2bBZlhvlwbUg</place-id>
    </location>
    <location>
      <name>N&#238;mes, Gard, France</name>
      <place-id>Sut8q82bBZkF0s1eTg</place-id>
    </location>
    <location>
      <name>Ceggia, Venezia, Italia</name>
      <place-id>s9ulRieYA5TkNK9otw</place-id>
    </location>
    <location>
      <name>Comit&#225;n de Dom&#237;nguez, Comitan de Dominguez, M&#233;xico</name>
      <place-id>.51HvYKbBZnSAeNHWw</place-id>
    </location>
    <location>
      <name>Platanos Aitoloakarnanias, Etolia Kai Akarnania, Greece</name>
      <place-id>CmfJ2H.YA5QKpS56HQ</place-id>
    </location>
    <location>
      <name>Krak&#243;w, Krak&#243;w, Polska</name>
      <place-id>9bYc0l.bA5vPTGscQg</place-id>
    </location>
    <location>
      <name>Nakuru, Kenya</name>
      <place-id>VDprypWYA5sujnZphA</place-id>
    </location>
    <location>
      <name>Fez, Al Magreb</name>
      <place-id>BxOaGgSYA5R40Nm1RA</place-id>
    </location>
  </locations>
</rsp>
RESPONSE


require File.dirname(__FILE__) + '/../lib/fireeagle'