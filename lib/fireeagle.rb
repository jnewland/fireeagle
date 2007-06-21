%w[ cgi digest/sha1 net/http hpricot time ].each { |f| require f }

require 'fireeagle/base'
require 'fireeagle/application'
require 'fireeagle/user'
require 'fireeagle/location'
require 'fireeagle/version'
require 'fireeagle/exceptions'

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

class Object
  # A Ruby-ized realization of the K combinator, courtesy of Mikael Brockman.
  #
  #   def foo
  #     returning values = [] do
  #       values << 'bar'
  #       values << 'baz'
  #     end
  #   end
  #
  #   foo # => ['bar', 'baz']
  #
  #   def foo
  #     returning [] do |values|
  #       values << 'bar'
  #       values << 'baz'
  #     end
  #   end
  #
  #   foo # => ['bar', 'baz']
  #
  def returning(value)
   yield(value)
   value
  end
end