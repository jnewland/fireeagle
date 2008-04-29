Gem::Specification.new do |s|
  s.name = "fireeagle"
  s.version = "0.7.0"
  s.date = "2008-04-29"
  s.summary = "Ruby wrapper for Yahoo!'s FireEagle"
  s.email = "jnewland@gmail.com"
  s.homepage = "http://fireeagle.rubyforge.org"
  s.description = "Ruby wrapper for Yahoo!'s FireEagle"
  s.has_rdoc = true
  s.authors = ["Jesse Newland"]
  s.files = ["config/hoe.rb", "config/requirements.rb", "History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/fireeagle.rb", "lib/fireeagle/client.rb", "lib/fireeagle/location.rb", "lib/fireeagle/response.rb", "lib/fireeagle/user.rb", "lib/fireeagle/version.rb", "setup.rb", "tasks/environment.rake", "tasks/rspec.rake"]
  s.test_files = ["spec/fireeagle_location_spec.rb", "spec/fireeagle_response_spec.rb", "spec/fireeagle_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.add_dependency("rake", ["> 0.0.0"])
  s.add_dependency("hoe", ["> 0.0.0"])
  s.add_dependency("newgem", ["> 0.0.0"])
  s.add_dependency("rubigen", ["> 0.0.0"])
  s.add_dependency("oauth", ["> 0.0.0"])
  s.add_dependency("geo_ruby", ["> 0.0.0"])
end
