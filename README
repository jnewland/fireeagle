== NOTE

THIS DOESN'T WORK YET. :)

FireEagle[http://fireeagle.yahoo.net] (FE) is a system providing centralized management of user location information. FE allows 3rd party developers to update and/or access user's location data.

== Installation

 gem install fireeagle
 
== Usage

  client = FireEagle::Client.new(
    :consumer_key        => "<consumer key>",
    :consumer_secret     => "<consumer secret>",
    :access_token        => "[access token]",
    :access_token_secret => "[access token secret]")
  
  client.user
  client.update(:address => "California")
  client.user
  client.lookup(:address => "San Francisco")

Rubyforge Project Page:: http://rubyforge.org/projects/fireeagle
Author::    Jesse Newland (http://soylentfoo.jnewland.com) (jnewland@gmail.com[mailto:jnewland@gmail.com])
Copyright:: Copyright (c) 2008 Jesse Newland. Portions[http://pastie.caboo.se/private/oevvkdzl0zrdkf8s7hetg] Copyright (c) 2008 Yahoo!
License::   Distributed under the same terms as Ruby
