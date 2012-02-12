$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_permissive/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_permissive"
  s.version     = ActsPermissive::VERSION
  s.authors     = ["John Metta"]
  s.email       = ["mail@johnmetta.com"]
  s.homepage    = "https://github.com/mettadore/acts_permissive"
  s.summary     = "Arbitrary permissions system for Rails objects"
  s.description = "Allows for arbitrary permissions on arbitrary collections of objects, rather than system-wide role based management"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.markdown"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1.1"
  s.add_dependency "uuidtools"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec"
  s.add_development_dependency "spork", '~> 0.9.0.rc'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "simplecov"
  s.add_development_dependency 'growl'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'fakeweb'
end
