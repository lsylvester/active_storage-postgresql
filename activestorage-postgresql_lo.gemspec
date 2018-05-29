$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "activestorage/postgresql_lo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activestorage-postgresql_lo"
  s.version     = Activestorage::PostgresqlLo::VERSION
  s.authors     = ["Lachlan Sylvester"]
  s.email       = ["lachlan.sylvester@publicisfrontfoot.com.au"]
  s.homepage    = "https://github.com/lsylvester/activestorage-postgresql_lo"
  s.summary     = "Postgresql Lo Adapter for Active Storage"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
end
