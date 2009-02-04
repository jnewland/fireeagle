(in /Users/snf/Documents/Projects/fireeagle)
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fireeagle}
  s.version = "0.8.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jesse Newland"]
  s.date = %q{2009-02-03}
  s.description = %q{Ruby wrapper for Yahoo!'s FireEagle}
  s.email = ["jnewland@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["config/hoe.rb", "config/requirements.rb", "History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/fireeagle.rb", "lib/fireeagle/client.rb", "lib/fireeagle/error.rb", "lib/fireeagle/location.rb", "lib/fireeagle/location_hierarchy.rb", "lib/fireeagle/locations.rb", "lib/fireeagle/response.rb", "lib/fireeagle/user.rb", "lib/fireeagle/version.rb", "setup.rb", "spec/fireeagle_response_spec.rb", "spec/fireeagle_spec.rb", "spec/location_spec.rb", "spec/locations_spec.rb", "spec/responses/error.xml", "spec/responses/exact_location_chunk.xml", "spec/responses/location_chunk.xml", "spec/responses/location_chunk_with_query.xml", "spec/responses/locations_chunk.xml", "spec/responses/lookup.xml", "spec/responses/recent.xml", "spec/responses/user.xml", "spec/responses/within.xml", "spec/spec.opts", "spec/spec_helper.rb", "tasks/environment.rake", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://fireeagle.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fireeagle}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby wrapper for Yahoo!'s FireEagle}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>, [">= 0.3.1"])
      s.add_runtime_dependency(%q<happymapper>, [">= 0.2.1"])
      s.add_runtime_dependency(%q<GeoRuby>, [">= 1.3.2"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<oauth>, [">= 0.3.1"])
      s.add_dependency(%q<happymapper>, [">= 0.2.1"])
      s.add_dependency(%q<GeoRuby>, [">= 1.3.2"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<oauth>, [">= 0.3.1"])
    s.add_dependency(%q<happymapper>, [">= 0.2.1"])
    s.add_dependency(%q<GeoRuby>, [">= 1.3.2"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
