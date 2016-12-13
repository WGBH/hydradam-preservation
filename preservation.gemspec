$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "preservation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "preservation"
  s.version     = Preservation::VERSION
  s.authors     = ["Andrew Myers"]
  s.email       = ["afredmyers@gmail.com"]
  s.summary = "Preservation features for Hydra"
  s.description = "Preservation features for Hydra"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
  s.add_dependency "curation_concerns", "~> 1.6.3"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'solr_wrapper'
  s.add_development_dependency 'fcrepo_wrapper'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'pry-byebug'
end
