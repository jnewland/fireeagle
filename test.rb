require 'lib/fireeagle'

class FireEagle
  API_SERVER = "http://localhost:3000"
end


local_client = FireEagle::Client.new \
  :consumer_key        => "rsrh5mbivz44",
  :consumer_secret     => "s0c73ld4krw3bss0js4cpmpomyvmi98o",
  :access_token        => "r9mfd1whj9l8",
  :access_token_secret => "03zf4kj0vr1m5oklc1dqgk6ez0hx0fe3"


user_client = FireEagle::Client.new \
  :consumer_key        => "rsrh5mbivz44",
  :consumer_secret     => "s0c73ld4krw3bss0js4cpmpomyvmi98o",
  :access_token        => "er56rlt9nygo",
  :access_token_secret => "sqllwf7pvflcd16sg0mrpj3mf9usrhxh"

app_client = FireEagle::Client.new \
  :consumer_key        => "rsrh5mbivz44",
  :consumer_secret     => "s0c73ld4krw3bss0js4cpmpomyvmi98o",
  :access_token        => "iokuy8fzc01h",
  :access_token_secret => "xibbbt1z2736zk9glt1ai0r4ctw4332f",
  :format              => FireEagle::FORMAT_JSON
  
  