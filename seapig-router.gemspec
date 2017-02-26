$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "seapig-router/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "seapig-router"
  s.version     = SeapigRouter::VERSION
  s.authors     = ["yunta"]
  s.email       = ["maciej.blomberg@mikoton.com"]
  s.homepage    = "https://github.com/yunta-mb/seapig-rails"
  s.summary     = "Transient object synchronization lib - rails"
  s.description = "meh"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc", "bin/seapig-*"]
  s.test_files = Dir["test/**/*"]
  s.executables = ["seapig-router-session-manager"]
  s.require_paths = ["lib"]

  s.add_dependency "activerecord"
  s.add_dependency "slop"
  s.add_dependency "seapig-client-ruby", "~> 0.2.0"
  s.add_dependency "seapig-postgresql-notifier", "~> 0.2.0"
  s.add_dependency "pg"
end
