FireEagle[http://fireeagle.yahoo.net] (FE) is a system providing centralized
management of user location information. FE allows 3rd party developers to
pdate and/or access user's location data.

http://fireeagle.yahoo.net/developer/documentation

== Installation

 gem install fireeagle
 
== Usage

  >> require 'fireeagle'
  >> client = FireEagle::Client.new(
    :consumer_key        => "<consumer key>",
    :consumer_secret     => "<consumer secret>",
    :access_token        => "[access token]",
    :access_token_secret => "[access token secret]")

==== With a User-specific OAuth Access Token

  # update your location
  >> client.update(:q => "punta del diablo, uruguay") # I wish
  # query your location
  >> user = client.user
  => #<FireEagle::User:0x1ca5e08 ... >
  >> user.locations
  => [#<FireEagle::Location:0x1cdd9e8 ...>, #<FireEagle::Location:0x1cc8ffc ...>, ... ]
  >> user.best_guess
  => #<FireEagle::Location:0x1cdd9e8 ...>
  >> user.best_guess.name
  => "Punta del Diablo, Uruguay"
  # lookup a location
  >> locations = client.lookup(:q => "30022")
  => [#<FireEagle::Location:0x1cdd9e8 ...>, #<FireEagle::Location:0x1cc8ffc ...>, ...]
  >> locations.first.name => "Alpharetta, GA 30022"
  >> locations.first.place_id => "IrhZMHuYA5s1fFi4Qw"

== Authorization

Authorization is handled by OAuth. For more details about the OAuth
authorization flow and how it differs based on your application type, please
see http://fireeagle.yahoo.net/developer/documentation/authorizing

Rubyforge Project Page:: http://rubyforge.org/projects/fireeagle
Author::    Jesse Newland (http://soylentfoo.jnewland.com) (jnewland@gmail.com[mailto:jnewland@gmail.com])
Copyright:: Copyright (c) 2008 Jesse Newland. Portions[http://pastie.caboo.se/private/oevvkdzl0zrdkf8s7hetg] Copyright (c) 2008 Yahoo!
License::   Distributed under the same terms as Ruby
