class FireEagle
  class Client
    attr_reader :access_token, :consumer, :format

    # Initialize a FireEagle Client. Takes an options Hash.
    #
    # == Required keys:
    #
    # [<tt>:consumer_key</tt>]       OAuth Consumer key representing your FireEagle Application
    # [<tt>:consumer_secret</tt>]    OAuth Consumer secret representing your FireEagle Application
    #
    # == Optional keys:
    #
    # [<tt>:access_token</tt>]           OAuth Token, either User-specific or General-purpose
    # [<tt>:access_token_secret</tt>]    OAuth Token, either User-specific or General-purpose
    # [<tt>:debug</tt>]                  Boolean
    #
    # User-specific OAuth tokens tie FireEagle users to your application. As such, they are intended to be
    # distributed (with keys) to that user's mobile device and/or computer running your desktop or mobile client.
    # For web-based applications User-specific tokens will be retrieved by your web server where they should be
    # treated as private data. Take care to avoid releasing this data to the public, as the corresponding User's location
    # information may be inadvertently exposed. User-specific OAuth tokens should be considered the property of
    # your users.
    #
    # General-purpose OAuth tokens are tied to your application and allow you, as a developer, to make more
    # general (often batch-style) queries against FireEagle. As a result, allowing this token/secret combination
    # loose has the potential to reveal a much greater amount of personal data. In an attempt to mitigate this, we will
    # only grant general-purpose tokens to web applications (contact us with details, if you seek an exception). In
    # addition, we require developers to provide a restrictive IP range at registration time in order to further mitigate
    # the risk of general−purpose tokens being used inappropriately.
    #
    # In general, OAuth tokens should be considered sacrosanct in order to help us respect our users' privacy. Please
    # take this responsibility on as your own. If your Application Oauth tokens are compromised, FireEagle will
    # turn off your application service until the problem is resolved.
    #
    # If the Client is initialized without an OAuth Token, it's assumed you're operating a non-web based application.
    #
    # == Non web-based applications
    #
    # For non web-based applications, such as a mobile client application, the authentication between the user and
    # the application is slightly different. The request token is displayed to the user by the client application. The
    # user then logs into the FireEagle website (using request_token_url) and enters this code to authorize the application.
    # When the user finishes the authorization step the client application exchanges the request token for an access token
    # (using convert_to_access_token). This is a lightweight method for non−web application users to authenticate an application
    # without entering any identifying information into a potentially insecure application. Request tokens are valid for only
    # 1 hour after being issued.
    def initialize(options = {})
      options = {
        :debug  => false,
        :format => FireEagle::FORMAT_XML
      }.merge(options)
    
      # symbolize keys
      options.map do |k,v|
        options[k.to_sym] = v
      end
      raise FireEagle::ArgumentError, "OAuth Consumer Key and Secret required" if options[:consumer_key].nil? || options[:consumer_secret].nil?
      @consumer = OAuth::Consumer.new(options[:consumer_key], options[:consumer_secret])
      @debug = options[:debug]
      @format = options[:format]
      if options[:access_token] && options[:access_token_secret]
        @access_token = OAuth::Token.new(options[:access_token], options[:access_token_secret])
      else
        @access_token = nil
      end
    end
    
    # Obtain an OAuth Reuest token and return the URL the user must access to authorize this token. For use by Non web-based applications.
    def request_token_url
      response = get(FireEagle::REQUEST_TOKEN_PATH, :token => nil)
      @request_token = create_token(response)
      return "#{FireEagle::AUTHORIZATION_URL}?oauth_token=#{@request_token.token}"
    end

    #Exchange an authorized OAuth Request token for an access token. For use by Non web-based applications.
    def convert_to_access_token
      raise FireEagle::ArgumentError, "call #request_token_url and have user authorize the token first" if @request_token.nil?
      response = get(FireEagle::ACCESS_TOKEN_PATH, :token => @request_token)
      @access_token = create_token(response)
    end

    # Interactively proceed through the OAuth Request token exchange process. For use by Non web-based applications in debud mode only.
    def get_access_token
      raise FireEagle::ArgumentError, "OAuth Access Token Required" unless debug?
      response = get(FireEagle::REQUEST_TOKEN_PATH, :token => nil)
      
      puts response.body
      
      request_token = create_token(response)
      
      puts request_token.inspect
    
      ## User interaction required
    
      puts "Authorize this: #{FireEagle::AUTHORIZATION_URL}?oauth_token=#{request_token.token}"
      print "<waiting>"
      $stdin.gets
    
      ## Back to our regularly scheduled access token retrieval
    
      response = get(FireEagle::ACCESS_TOKEN_PATH, :token => request_token)
      puts response.body
      @access_token = create_token(response)
      puts "Access token: #{@access_token.inspect}"
    end

    # Disambiguates potential values for update query. Results from lookup can be passed to
    # update to ensure that FireEagle will understand how to parse the Location Hash.
    #
    # All three Location methods (lookup, update, and within) accept a Location Hash.
    #
    # There is a specific order for looking up locations. For example, if you provide lat, lon, and address,
    # FireEagle will use the the latitude and longitude geo-coordinates and ignore the address.
    # 
    # Location Hash keys, in order of priority:
    # 
    # [<tt>(:lat, :lon)</tt>]              both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
    # [<tt>:'place-id'</tt>]                Place ID - valid values decrypts to an integer value 
    # [<tt>:geom</tt>]                    a GeoJSON / GeoRSS element such as a bounding box, shape file, polygon, or point
    # [<tt>:address</tt>]                 street address (may contain a full address, but will be combined with postal, city, state, and country when available) 
    # [<tt>(:mnc, :mcc, :lac, :cid)</tt>]    cell tower information, all required (as integers) for a valid tower location
    # [<tt>:postal</tt>]                  a ZIP or postal code (combined with address, city, state, and country when available)
    # [<tt>:city</tt>]                    city (combined with address, postal, state, and country when available)
    # [<tt>:state</tt>]                   state (combined with address, postal, city, and country when available)
    # [<tt>:country</tt>]                 country (combined with address, postal, city, and state when available)
    # [<tt>:q</tt>]                       Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is. 
    # 
    # Not yet supported:
    # 
    # * <tt>upcoming-venue-id</tt>
    # * <tt>yahoo-local-id</tt>
    # * <tt>plazes-id</tt>
    def lookup(params)
      get_access_token unless @access_token

      response = get(FireEagle::LOOKUP_API_PATH + ".#{format}", :params => params)

      if json?
        JSON.parse(response.body)
      else
        FireEagle::Response.new(response.body).locations
      end
    end

    # Sets a User's current Location using using a Place ID hash or a set of Location parameters. If the User
    # provides a Location unconfirmed with lookup then FireEagle makes a best guess as to the User's Location.
    #
    # All three Location methods (lookup, update, and within) accept a Location Hash.
    #
    # There is a specific order for looking up locations. For example, if you provide lat, lon, and address,
    # FireEagle will use the the latitude and longitude geo-coordinates and ignore the address.
    # 
    # Location Hash keys, in order of priority:
    # 
    # [<tt>(:lat, :lon)</tt>]              both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
    # [<tt>:'place-id'</tt>]                Place ID - valid values decrypts to an integer value 
    # [<tt>:geom</tt>]                    a GeoJSON / GeoRSS element such as a bounding box, shape file, polygon, or point
    # [<tt>:address</tt>]                 street address (may contain a full address, but will be combined with postal, city, state, and country when available) 
    # [<tt>(:mnc, :mcc, :lac, :cid)</tt>]    cell tower information, all required (as integers) for a valid tower location
    # [<tt>:postal</tt>]                  a ZIP or postal code (combined with address, city, state, and country when available)
    # [<tt>:city</tt>]                    city (combined with address, postal, state, and country when available)
    # [<tt>:state</tt>]                   state (combined with address, postal, city, and country when available)
    # [<tt>:country</tt>]                 country (combined with address, postal, city, and state when available)
    # [<tt>:q</tt>]                       Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is. 
    #
    # Not yet supported:
    #
    # * <tt>upcoming-venue-id</tt>
    # * <tt>yahoo-local-id</tt>
    # * <tt>plazes-id</tt>
    def update(location = {})
      get_access_token unless @access_token

      location = sanitize_location_hash(location)

      response = post(FireEagle::UPDATE_API_PATH + ".#{format}", :params => location)

      if json?
        JSON.parse(response.body)
      else
        FireEagle::Response.new(response.body)
      end
    end

    # Returns the Location of a User.
    def user
      get_access_token unless @access_token

      response = get(FireEagle::USER_API_PATH + ".#{format}")

      if json?
        JSON.parse(response.body)
      else
        FireEagle::Response.new(response.body).users.first
      end
    end
    alias_method :location, :user

    # Query for Users of an Application who have updated their Location recently. Returns a list of 
    # Users for the Application with recently updated locations.
    def recent(count = 10, start = 0)
      get_access_token unless @access_token

      params = { :count => count, :start => start }

      response = get(FireEagle::RECENT_API_PATH + ".#{format}", :params => params)

      if json?
        JSON.parse(response.body)
      else
        FireEagle::Response.new(response.body).users
      end
    end

    # Query for Users of an Application who have updated their Location recently. Returns a list of 
    # Users and their Locations at all levels the Application can see and larger.
    #
    # Location Hash keys, in order of priority:
    # 
    # [<tt>(:lat, :lon)</tt>]              both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
    # [<tt>:'place-id'</tt>]                Place ID - valid values decrypts to an integer value 
    # [<tt>:geom</tt>]                    a GeoJSON / GeoRSS element such as a bounding box, shape file, polygon, or point
    # [<tt>:address</tt>]                 street address (may contain a full address, but will be combined with postal, city, state, and country when available) 
    # [<tt>(:mnc, :mcc, :lac, :cid)</tt>]    cell tower information, all required (as integers) for a valid tower location
    # [<tt>:postal</tt>]                  a ZIP or postal code (combined with address, city, state, and country when available)
    # [<tt>:city</tt>]                    city (combined with address, postal, state, and country when available)
    # [<tt>:state</tt>]                   state (combined with address, postal, city, and country when available)
    # [<tt>:country</tt>]                 country (combined with address, postal, city, and state when available)
    # [<tt>:q</tt>]                       Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is. 
    #
    # Not yet supported:
    # 
    # * <tt>upcoming-venue-id</tt>
    # * <tt>yahoo-local-id</tt>
    # * <tt>plazes-id</tt>
    def within(location = {}, count = 10, start = 0)
      get_access_token unless @access_token

      location = sanitize_location_hash(location)

      response = get(FireEagle::WITHIN_API_PATH + ".#{format}", :params => location)

      if json?
        JSON.parse(response.body)
      else
        FireEagle::Response.new(response.body).locations
      end
    end

  protected

    def sanitize_location_hash(location)
      location.map do |k,v|
        location[k.to_sym] = v
      end

      location = location.reject { |key, value| !FireEagle::UPDATE_PARAMS.include?(key) }
      raise FireEagle::ArgumentError, "Requires all or none of :lat, :lon" unless location.has_all_or_none_keys?(:lat, :lon)
      raise FireEagle::ArgumentError, "Requires all or none of :mnc, :mcc, :lac, :cellid" unless location.has_all_or_none_keys?(:mnc, :mcc, :lac, :cid)
      location
    end

    def xml? #:nodoc:
      format == FireEagle::FORMAT_XML
    end

    def json? #:nodoc:
      format == FireEagle::FORMAT_JSON
    end

    def create_token(response) #:nodoc:
      token = Hash[*response.body.split("&").map { |x| x.split("=") }.flatten]
      OAuth::Token.new(token["oauth_token"], token["oauth_token_secret"])
    end

    # Is the Client in debug mode?
    def debug?
      @debug == true
    end

    def get(url, options = {}) #:nodoc:
      request(:get, url, options)
    end

    def post(url, options = {}) #:nodoc:
      request(:post, url, options)
    end

    def request(method, url, options) #:nodoc:
      options = {
        :params => {},
        :token  => @access_token
      }.merge(options)

      request_uri = URI.parse(FireEagle::SERVER + url)
      http = Net::HTTP.new(request_uri.host, request_uri.port)
      http.set_debug_output $stderr if debug?
      if FireEagle::SERVER =~ /https:/
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = nil
      if method == :post
        request = Net::HTTP::Post.new(request_uri.path)
        request.set_form_data(options[:params])
      elsif method == :get
        qs = options[:params].collect { |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
        request = Net::HTTP::Get.new(request_uri.path + "?" + qs)
      end
      request.oauth!(http, consumer, options[:token])
      response = http.request(request)
      raise FireEagle::FireEagleException, "Internal Server Error" if response.code == '500'
      raise FireEagle::FireEagleException, "Method Not Implemented Yet" if response.code == '400'
      response
    end

  end
end