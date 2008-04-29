(in /Users/snf/Documents/Projects/fireeagle)
Gem::Specification.new do |s|
  s.name = %q{fireeagle}
  s.version = "0.7.0.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jesse Newland"]
  s.date = %q{2008-04-29}
  s.description = %q{Ruby wrapper for Yahoo!'s FireEagle}
  s.email = ["jnewland@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["config/hoe.rb", "config/requirements.rb", "History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/fireeagle.rb", "lib/fireeagle/client.rb", "lib/fireeagle/location.rb", "lib/fireeagle/response.rb", "lib/fireeagle/user.rb", "lib/fireeagle/version.rb", "setup.rb", "spec/fireeagle_location_spec.rb", "spec/fireeagle_response_spec.rb", "spec/fireeagle_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/environment.rake", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://fireeagle.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fireeagle}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Ruby wrapper for Yahoo!'s FireEagle}

  s.add_dependency(%q<oauth>, [">= 0.2.1"])
  s.add_dependency(%q<hpricot>, [">= 0.6"])
  s.add_dependency(%q<GeoRuby>, [">= 1.3.2"])
end
