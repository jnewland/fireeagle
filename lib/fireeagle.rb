require 'net/https'
require 'rubygems'
gem 'oauth', ">= 0.2.1"
require 'oauth/client/helper'
require 'oauth/request_proxy/net_http'
require 'json'

module FireEagle
  SERVER = "http://fireagle.yahoo.net"
  REQUEST_TOKEN_PATH = "/oauth/request_token"
  ACCESS_TOKEN_PATH  = "/oauth/access_token"
  AUTHORIZATION_URL  = SERVER + "/oauth/authorize"
  USER_API_PATH      = "/api/0.1/user"
  LOOKUP_API_PATH    = "/api/0.1/lookup"
  UPDATE_API_PATH    = "/api/0.1/update"
  FORMAT_JSON        = "json"
  FORMAT_XML
end