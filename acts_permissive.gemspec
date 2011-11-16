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
  s.summary     = "Blah blah"
  s.description = "yada yada"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"
  s.add_dependency "uuidtools"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec"
  s.add_development_dependency "spork", '~> 0.9.0.rc'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "simplecov"
  s.add_development_dependency 'growl'
  s.add_development_dependency 'rb-fsevent'
end
