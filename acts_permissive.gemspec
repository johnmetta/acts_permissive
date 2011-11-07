$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_permissive/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = %q{acts_permissive}
  s.version     = ActsPermissive::VERSION
  s.authors     = %q{John Metta}
  s.email       = %q{mail@johnmetta.com}
  s.homepage    = %q{https://github.com/mettadore/acts_permissive.git}
  s.summary     = %q{Permissions system, byte additive, extensible}
  s.description = %q{Rails plugin providing expanded Unix-like permissions system for Ruby objects}

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"

  s.add_dependency "uuidtools"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "sqlite3"
end
