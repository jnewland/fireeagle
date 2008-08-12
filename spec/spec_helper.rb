begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end
require 'time'

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

XML_QUERY_LOCATION_CHUNK = <<-RESPONSE
<location best-guess="true">
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

XML_WITHIN_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="ok">
  <users>
    <user token="MQdDrJgXMNJi">
      <location-hierarchy>
        <location best-guess="true">
          <id>111541</id>
          <georss:point>32.7093315125 -117.1650772095</georss:point>
          <level>0</level>
          <level-name>exact</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>333 W Harbor Dr, San Diego, CA</name>
        </location>
        <location best-guess="false">
          <id>111551</id>
          <georss:box>
            32.6916618347 -117.2174377441 32.744140625 -117.1458892822
          </georss:box>
          <level>1</level>
          <level-name>postal</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>San Diego, CA 92101</name>
          <place-id>NpiXqwmYA5viX3K3Ew</place-id>
          <woeid>12796255</woeid>
        </location>
        <location best-guess="false">
          <id>111561</id>
          <georss:box>
            32.5349388123 -117.2884292603 33.1128082275 -116.9142913818
          </georss:box>
          <level>3</level>
          <level-name>city</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>San Diego, CA</name>
          <place-id>Nm4O.DebBZTYKUsu</place-id>
          <woeid>2487889</woeid>
        </location>
        <location best-guess="false">
          <id>111571</id>
          <georss:box>
            32.5342788696 -124.4150238037 42.0093803406 -114.1308135986
          </georss:box>
          <level>5</level>
          <level-name>state</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>California</name>
          <place-id>SVrAMtCbAphCLAtP</place-id>
          <woeid>2347563</woeid>
        </location>
        <location best-guess="false">
          <id>111581</id>
          <georss:box>
            18.9108390808 -167.2764129639 72.8960571289 -66.6879425049
          </georss:box>
          <level>6</level>
          <level-name>country</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>United States</name>
          <place-id>4KO02SibApitvSBieQ</place-id>
          <woeid>23424977</woeid>
        </location>
      </location-hierarchy>
    </user>
    <user token="MQdDrJgXMNJi">
      <location-hierarchy>
        <location best-guess="true">
          <id>111541</id>
          <georss:point>32.7093315125 -117.1650772095</georss:point>
          <level>0</level>
          <level-name>exact</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>333 W Harbor Dr, San Diego, CA</name>
        </location>
        <location best-guess="false">
          <id>111551</id>
          <georss:box>
            32.6916618347 -117.2174377441 32.744140625 -117.1458892822
          </georss:box>
          <level>1</level>
          <level-name>postal</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>San Diego, CA 92101</name>
          <place-id>NpiXqwmYA5viX3K3Ew</place-id>
          <woeid>12796255</woeid>
        </location>
        <location best-guess="false">
          <id>111561</id>
          <georss:box>
            32.5349388123 -117.2884292603 33.1128082275 -116.9142913818
          </georss:box>
          <level>3</level>
          <level-name>city</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>San Diego, CA</name>
          <place-id>Nm4O.DebBZTYKUsu</place-id>
          <woeid>2487889</woeid>
        </location>
        <location best-guess="false">
          <id>111571</id>
          <georss:box>
            32.5342788696 -124.4150238037 42.0093803406 -114.1308135986
          </georss:box>
          <level>5</level>
          <level-name>state</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>California</name>
          <place-id>SVrAMtCbAphCLAtP</place-id>
          <woeid>2347563</woeid>
        </location>
        <location best-guess="false">
          <id>111581</id>
          <georss:box>
            18.9108390808 -167.2764129639 72.8960571289 -66.6879425049
          </georss:box>
          <level>6</level>
          <level-name>country</level-name>
          <located-at>2008-03-03T09:05:16-08:00</located-at>
          <name>United States</name>
          <place-id>4KO02SibApitvSBieQ</place-id>
          <woeid>23424977</woeid>
        </location>
      </location-hierarchy>
    </user>
  </users>
</rsp>
RESPONSE

XML_RECENT_RESPONSE = <<-RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<rsp xmlns:georss="http://www.georss.org/georss" stat="ok">
  <users>
    <user located-at="2008-07-31T22:31:37+12:00" token="5pyl1xip0uh6"/>
    <user located-at="2008-07-31T21:49:03+12:00" token="i71yc3myixg3"/>
    <user located-at="2008-07-30T21:40:54+12:00" token="q1jm8nubnpsi"/>
  </users>
</rsp>
RESPONSE

require File.dirname(__FILE__) + '/../lib/fireeagle'
