FireEagle[http://fireeagle.research.yahoo.com/] (FE) is a system providing centralized management of user location information. FE allows 3rd party developers to update and/or access user's location data.

== Installation

 gem install fireeagle
 
== Usage

 require 'fireeagle'
 f = FireEagle.new(:token => "foo", :secret => "bar")
 user = FireEagle::User.new(f,"token")
 l = FireEagle::Location.new(:country => "Belize")
 user.location = l
 user.location
 =>  #<FireEagle::Location:0x15ba0d0 @details={:country=>"Belize"}>

 Rubyforge Project Page:: http://rubyforge.org/projects/fireeagle
 Author::    Jesse Newland (http://soylentfoo.jnewland.com) (jnewland@gmail.com[mailto:jnewland@gmail.com])
 Copyright:: Copyright (c) 2007 Jesse Newland
 License::   Distributes under the same terms as Ruby