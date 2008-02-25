require 'time'
require 'net/https'
require 'rubygems'
gem 'oauth', ">= 0.2.1"
require 'oauth/client/helper'
require 'oauth/request_proxy/net_http'
require 'json'
require 'hpricot'

class FireEagle
  SERVER = "http://fireeagle.yahoo.net"
  REQUEST_TOKEN_PATH = "/oauth/request_token"
  ACCESS_TOKEN_PATH  = "/oauth/access_token"
  AUTHORIZATION_URL  = "#{SERVER}/oauth/authorize"
  USER_API_PATH      = "/api/0.1/user"
  LOOKUP_API_PATH    = "/api/0.1/lookup"
  UPDATE_API_PATH    = "/api/0.1/update"
  RECENT_API_PATH    = "/api/0.1/recent"
  WITHIN_API_PATH    = "/api/0.1/within"
  FORMAT_JSON        = "json"
  FORMAT_XML         = "xml"
  UPDATE_PARAMS      = :lat, :lon, :'place-id', :geom, :address, :mnc, :mcc, :lac, :cid, :postal, :city, :state, :country, :q,
                        #not yet supported
                        :'upcoming-venue-id', :'yahoo-local-id', :'plazes-id'

  class Error < RuntimeError #:nodoc:
  end

  class ArgumentError < Error #:nodoc:
  end

  class FireEagleException < Error #:nodoc:
  end
end

#FireEagle additions to the <code>Hash</code> class
class Hash
  #Returns <code>true</code> if the ALL or NONE of the given keys are present in <i>hsh</i>.
  def has_all_or_none_keys?(*my_keys)
    size = my_keys.length
    false_count = 0
    my_keys.each do |k|
      false_count += 1 unless keys.include?(k)
    end
    false_count == 0 or false_count == size
  end
end

require File.dirname(__FILE__) + '/fireeagle/client'
require File.dirname(__FILE__) + '/fireeagle/location'
require File.dirname(__FILE__) + '/fireeagle/user'
require File.dirname(__FILE__) + '/fireeagle/response'