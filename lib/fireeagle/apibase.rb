class FireEagle::APIBase < FireEagle::Base #:nodoc:
	def initialize(fireeagle)
	   super(:token => fireeagle.token, :secret => fireeagle.secret)
	   @fireeagle = fireeagle
	end
end