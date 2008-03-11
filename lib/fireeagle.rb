require 'time'
require 'net/https'
require 'rubygems'
gem 'oauth', ">= 0.2.1"
require 'oauth/client/helper'
require 'oauth/request_proxy/net_http'
require 'hpricot'
require 'geo_ruby'

class FireEagle
  API_SERVER = "https://fireeagle.yahooapis.com"
  AUTH_SERVER = "https://fireeagle.yahoo.net"
  REQUEST_TOKEN_PATH = "/oauth/request_token"
  ACCESS_TOKEN_PATH  = "/oauth/access_token"
  AUTHORIZATION_URL  = "#{AUTH_SERVER}/oauth/authorize"
  MOBILE_AUTH_URL    = "#{AUTH_SERVER}/oauth/mobile_auth/"
  USER_API_PATH      = "/api/0.1/user"
  LOOKUP_API_PATH    = "/api/0.1/lookup"
  UPDATE_API_PATH    = "/api/0.1/update"
  RECENT_API_PATH    = "/api/0.1/recent"
  WITHIN_API_PATH    = "/api/0.1/within"
  FORMAT_XML         = "xml"
  UPDATE_PARAMS      = :lat, :lon, :woeid, :place_id, :address, :mnc, :mcc, :lac, :cellid, :postal, :city, :state, :country, :q, :label
                        # not yet supported
                        #,:geom, :upcoming_venue_id, :yahoo_local_id, :plazes_id

  class Error < RuntimeError #:nodoc:
  end

  class ArgumentError < Error #:nodoc:
  end

  class FireEagleException < Error #:nodoc:
  end
end

#FireEagle additions to the <code>Hash</code> class
class Hash
  #Returns <code>true</code> if the ALL or NONE of the given keys are present in <i>my_keys</i>.
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