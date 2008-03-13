class FireEagle
  class Client
    attr_reader :access_token, :request_token, :consumer, :format

    # Initialize a FireEagle Client. Takes an options Hash.
    #
    # == Required keys:
    #
    # [<tt>:consumer_key</tt>]       OAuth Consumer key representing your FireEagle Application
    # [<tt>:consumer_secret</tt>]    OAuth Consumer secret representing your FireEagle Application
    #
    # == Optional keys:
    #
    # [<tt>:request_token</tt>]           OAuth Request Token, for use with convert_to_access_token
    # [<tt>:request_token_secret</tt>]    OAuth Request Token Secret, for use with convert_to_access_token
    # [<tt>:access_token</tt>]           OAuth Token, either User-specific or General-purpose
    # [<tt>:access_token_secret</tt>]    OAuth Token, either User-specific or General-purpose
    # [<tt>:app_id</tt>]                 Your Mobile Application ID
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
    # the risk of general-purpose tokens being used inappropriately.
    #
    # In general, OAuth tokens should be considered sacrosanct in order to help us respect our users' privacy. Please
    # take this responsibility on as your own. If your Application Oauth tokens are compromised, FireEagle will
    # turn off your application service until the problem is resolved.
    #
    # If the Client is initialized without an OAuth access token, it's assumed you're operating a non-web based application.
    #
    # == Non web-based applications
    #
    # For non web-based applications, such as a mobile client application, the authentication between the user and
    # the application is slightly different. The request token is displayed to the user by the client application. The
    # user then logs into the FireEagle website (using mobile_authorization_url) and enters this code to authorize the application.
    # When the user finishes the authorization step the client application exchanges the request token for an access token
    # (using convert_to_access_token). This is a lightweight method for non-web application users to authenticate an application
    # without entering any identifying information into a potentially insecure application. Request tokens are valid for only
    # 1 hour after being issued.
    #
    # == Example mobile-based authentication flow:
    #
    # Initialize a client with your consumer key, consumer secret, and your mobile application id:
    #
    #   >> c = FireEagle::Client.new(:consumer_key => "key", :consumer_secret => "sekret", :app_id => 12345)
    #   => #<FireEagle::Client:0x1ce2e70 ... >
    #
    # Generate a request token:
    #
    #   >> c.get_request_token
    #   => #<OAuth::Token:0x1cdb5bc @token="ENTER_THIS_TOKEN", @secret="sekret">
    #
    # Prompt your user to visit your app's mobile authorization url and enter ENTER_THIS_TOKEN:
    #
    #   >> c.mobile_authorization_url
    #   => "http://fireeagle.yahoo.net/oauth/mobile_auth/12345"
    #
    # Once the user has indicated to you that they've done this, convert their request token to an access token:
    #
    #   >> c.convert_to_access_token
    #   => #<OAuth::Token:0x1cd3bf0 @token="access_token", @secret="access_token_secret">
    #
    # You're done!
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
      @consumer = OAuth::Consumer.new(options[:consumer_key], options[:consumer_secret], :site => FireEagle::API_SERVER, :authorize_url => FireEagle::AUTHORIZATION_URL)
      @debug    = options[:debug]
      @format   = options[:format]
      @app_id   = options[:app_id]
      if options[:access_token] && options[:access_token_secret]
        @access_token = OAuth::AccessToken.new(@consumer, options[:access_token], options[:access_token_secret])
      else
        @access_token = nil
      end
      if options[:request_token] && options[:request_token_secret]
        @request_token = OAuth::RequestToken.new(@consumer, options[:request_token], options[:request_token_secret])
      else
        @request_token = nil
      end
    end

    # Obtain an <strong>new</strong> unauthorized OAuth Request token
    def get_request_token(force_token_regeneration = false)
      if force_token_regeneration || @request_token.nil?
        @request_token = consumer.get_request_token
      end
      @request_token
    end

    # Return the Fire Eagle authorization URL for your mobile application. At this URL, the User will be prompted for their request_token.
    def mobile_authorization_url
      raise FireEagle::ArgumentError, ":app_id required" if @app_id.nil?
      "#{FireEagle::MOBILE_AUTH_URL}#{@app_id}"
    end

    # The URL the user must access to authorize this token. request_token must be called first. For use by web-based and desktop-based applications.
    def authorization_url
      raise FireEagle::ArgumentError, "call #get_request_token first" if @request_token.nil?
      request_token.authorize_url
    end

    #Exchange an authorized OAuth Request token for an access token. For use by desktop-based and mobile applications.
    def convert_to_access_token
      raise FireEagle::ArgumentError, "call #get_request_token and have user authorize the token first" if @request_token.nil?
      @access_token = request_token.get_access_token
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
    # [<tt>(:lat, :lon)</tt>]                   both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
    # [<tt>(:woeid)</tt>]                       Where on Earth ID
    # [<tt>:place_id</tt>]                      Place ID (via Flickr/Upcomoing); deprecated in favor of WOE IDs when possible
    # [<tt>:address</tt>]                       street address (may contain a full address, but will be combined with postal, city, state, and country when available)
    # [<tt>(:mnc, :mcc, :lac, :cellid)</tt>]    cell tower information, all required (as integers) for a valid tower location
    # [<tt>:postal</tt>]                        a ZIP or postal code (combined with address, city, state, and country when available)
    # [<tt>:city</tt>]                          city (combined with address, postal, state, and country when available)
    # [<tt>:state</tt>]                         state (combined with address, postal, city, and country when available)
    # [<tt>:country</tt>]                       country (combined with address, postal, city, and state when available)
    # [<tt>:q</tt>]                             Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is.
    #
    # Not yet supported:
    #
    # * <tt>upcoming_venue_id</tt>
    # * <tt>yahoo_local_id</tt>
    # * <tt>plazes_id</tt>
    def lookup(params)
      raise FireEagle::ArgumentError, "OAuth Access Token Required" unless @access_token
      response = get(FireEagle::LOOKUP_API_PATH + ".#{format}", :params => params)
      FireEagle::Response.new(response.body).locations
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
    # [<tt>(:lat, :lon)</tt>]                   both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
    # [<tt>:place_id</tt>]                      Place ID - valid values decrypts to an integer value
    # [<tt>:address</tt>]                       street address (may contain a full address, but will be combined with postal, city, state, and country when available)
    # [<tt>(:mnc, :mcc, :lac, :cellid)</tt>]    cell tower information, all required (as integers) for a valid tower location
    # [<tt>:postal</tt>]                        a ZIP or postal code (combined with address, city, state, and country when available)
    # [<tt>:city</tt>]                          city (combined with address, postal, state, and country when available)
    # [<tt>:state</tt>]                         state (combined with address, postal, city, and country when available)
    # [<tt>:country</tt>]                       country (combined with address, postal, city, and state when available)
    # [<tt>:q</tt>]                             Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is.
    #
    # Not yet supported:
    #
    # * <tt>upcoming_venue_id</tt>
    # * <tt>yahoo_local_id</tt>
    # * <tt>plazes_id</tt>
    def update(location = {})
      raise FireEagle::ArgumentError, "OAuth Access Token Required" unless @access_token
      location = sanitize_location_hash(location)
      response = post(FireEagle::UPDATE_API_PATH + ".#{format}", :params => location)
      FireEagle::Response.new(response.body)
    end

    # Returns the Location of a User.
    def user
      raise FireEagle::ArgumentError, "OAuth Access Token Required" unless @access_token

      response = get(FireEagle::USER_API_PATH + ".#{format}")

      FireEagle::Response.new(response.body).users.first
    end
    alias_method :location, :user

    # Query for Users of an Application who have updated their Location recently. Returns a list of
    # Users for the Application with recently updated locations.
    #
    # == Optional parameters:
    #
    # <tt>count</tt>  Number of users to return per page. (default: 10)
    # <tt>start</tt>  The page number at which to start returning the list of users. Pages are 0-indexed, each page contains the per_page number of users. (default: 0)
    # <tt>time</tt>   The time to start looking at recent updates from. Value is flexible, supported forms are 'now', 'yesterday', '12:00', '13:00', '1:00pm' and '2008-03-12 12:34:56'. (default: 'now')
    def recent(count = 10, start = 0, time = 'now')
      raise FireEagle::ArgumentError, "OAuth Access Token Required" unless @access_token

      params = { :count => count, :start => start, :time => time }

      response = get(FireEagle::RECENT_API_PATH + ".#{format}", :params => params)

      FireEagle::Response.new(response.body).users
    end

    # Takes a Place ID or a Location and returns a list of users of your application who are within the bounding box of that Location.
    #
    # Location Hash keys, in order of priority:
    #
    # [<tt>(:lat, :lon)</tt>]                   both required, valid values are floats of -180 to 180 for lat and -90 to 90 for lon
    # [<tt>:woeid</tt>]                         Where on Earth ID
    # [<tt>:place_id</tt>]                      Place ID
    # [<tt>:address</tt>]                       street address (may contain a full address, but will be combined with postal, city, state, and country when available)
    # [<tt>(:mnc, :mcc, :lac, :cellid)</tt>]    cell tower information, all required (as integers) for a valid tower location
    # [<tt>:postal</tt>]                        a ZIP or postal code (combined with address, city, state, and country when available)
    # [<tt>:city</tt>]                          city (combined with address, postal, state, and country when available)
    # [<tt>:state</tt>]                         state (combined with address, postal, city, and country when available)
    # [<tt>:country</tt>]                       country (combined with address, postal, city, and state when available)
    # [<tt>:q</tt>]                             Free-text fallback containing user input. Lat/lon pairs and geometries will be extracted if possible, otherwise this string will be geocoded as-is.
    #
    # Not yet supported:
    #
    # * <tt>upcoming_venue_id</tt>
    # * <tt>yahoo_local_id</tt>
    # * <tt>plazes_id</tt>
    def within(location = {}, count = 10, start = 0)
      raise FireEagle::ArgumentError, "OAuth Access Token Required" unless @access_token

      location = sanitize_location_hash(location)
      params = { :count => count, :start => start }.merge(location)

      response = get(FireEagle::WITHIN_API_PATH + ".#{format}", :params => params)

      FireEagle::Response.new(response.body).users
    end

  protected

    def sanitize_location_hash(location)
      location.map do |k,v|
        location[k.to_sym] = v
      end

      location = location.reject { |key, value| !FireEagle::UPDATE_PARAMS.include?(key) }
      raise FireEagle::ArgumentError, "Requires all or none of :lat, :lon" unless location.has_all_or_none_keys?(:lat, :lon)
      raise FireEagle::ArgumentError, "Requires all or none of :mnc, :mcc, :lac, :cellid" unless location.has_all_or_none_keys?(:mnc, :mcc, :lac, :cellid)
      location
    end

    def xml? #:nodoc:
      format == FireEagle::FORMAT_XML
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
      qs = options[:params].collect { |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
      access_token.request(:get, "#{url}?#{qs}")
    end

    def post(url, options = {}) #:nodoc:
      access_token.request(:post, url, options[:params])
    end

    def request(method, url, options) #:nodoc:
      options = {
        :params => {},
        :token  => @access_token
      }.merge(options)

      request_uri = URI.parse(FireEagle::API_SERVER + url)
      http = Net::HTTP.new(request_uri.host, request_uri.port)
      http.set_debug_output $stderr if debug?
      if FireEagle::API_SERVER =~ /https:/
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
