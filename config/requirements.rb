require 'fileutils'
include FileUtils

require 'rubygems'
%w[rake hoe newgem rubigen oauth geo_ruby].each do |req_gem|
  begin
    require req_gem
  rescue LoadError
    req_gem = 'GeoRuby' if req_gem == 'geo_ruby' # gem not the same name
    puts "This Rakefile requires the '#{req_gem}' RubyGem."
    puts "Installation: gem install #{req_gem} -y"
    exit
  end
end

$:.unshift(File.join(File.dirname(__FILE__), %w[.. lib]))

require 'fireeagle'