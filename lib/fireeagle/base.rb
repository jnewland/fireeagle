class FireEagle

  API_DOMAIN = "fireeagle.research.yahoo.com"
  API_PATH = "/api/"
  DEBUG = true
  
  attr_reader :token, :secret
  
  def initialize(options = {})
    options = { :token => nil, :secret => nil }.merge(options)
    raise ArgumentError, "Token and Secret required" if options[:token].nil? || options[:secret].nil?
    @token = options[:token]
    @secret = options[:secret]
    @fireeagle = self
  end
  
  def application() @application ||= Application.new(self) end

private

  # do the required api signing
  def encode_and_sign(params = {})

    #check for the params
    raise ArgumentError, "Params required" if params == {} || !params.is_a?(Hash)

    #remove any provided sig
    params.delete(:sig)

    #add the app token id
    params[:appid] = @fireeagle.token

    #sort and URL encode the params
    normalized_params = {}
    params.each_pair { |name, value| normalized_params[name.to_s] = value.to_s }

    #build the string to sign
    sig = "#{@fireeagle.secret}"
    normalized_params.sort.each { |name, value| sig << "#{name}#{value}" } 

    #sign it
    normalized_params['sig'] = Digest::SHA1.hexdigest(sig)

    #create and return the request string
    request_string = "?" + normalized_params.sort.collect { |name, value| "#{name}=#{CGI::escape(value)}" }.join('&')
  end

  # request method which is used by all public methods
  def request(action = nil,params = {})
    raise ArgumentError, "Action name required" if action.nil?

    #reject crap
    params.reject { |key, value| value.nil? or (value.is_a?(String) and value.empty?)}
    #merge timestamp
    params.merge!( { :timestamp => Time.now.to_i } )

    path = "#{FireEagle::API_PATH}#{action}.php#{encode_and_sign(params)}"
    
    puts path if FireEagle::DEBUG

    response = Net::HTTP.get_response(FireEagle::API_DOMAIN, path)
    
    parse_response(Hpricot(response.body))   
  end
  
  def parse_response(doc)
    raise FireEagleException, doc.at("/resultset/errormessage").innerText unless !doc.at("/resultset").nil? and doc.at("/resultset/error").innerText.to_i == "0"
    doc.at("/result")
  end
  
  def fireeagle
    fireeagle
  end
  
  
end

class FireEagle::APIBase < FireEagle
	def initialize(fireeagle)
	   super(:token => fireeagle.token, :secret => fireeagle.secret)
	   @fireeagle = fireeagle
	end
end