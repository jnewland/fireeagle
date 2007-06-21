%w[ cgi digest/sha1 net/http hpricot time ].each { |f| require f }

require 'fireeagle/base'
require 'fireeagle/application'
require 'fireeagle/user'
require 'fireeagle/location'
require 'fireeagle/version'
require 'fireeagle/exceptions'