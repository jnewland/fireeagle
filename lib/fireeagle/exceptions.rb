class FireEagle
  class Error < RuntimeError #:nodoc:
  end

  class ArgumentError < Error #:nodoc:
  end
  
  class FireEagleException < Error #:nodoc:
  end
end