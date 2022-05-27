$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "active_storage/postgresql/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_storage-postgresql"
  s.version     = ActiveStorage::PostgreSQL::VERSION
  s.authors     = ["Lachlan Sylvester"]
  s.email       = ["lachlan.sylvester@hypothetical.com.au"]
  s.homepage    = "https://github.com/lsylvester/active_storage-postgresql"
  s.summary     = "PostgreSQL Adapter for Active Storage"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 6.0"
  s.add_dependency "pg", ">= 1.0", "< 1.3"

  s.add_development_dependency "pry", "~> 0.11"
  s.add_development_dependency "database_cleaner", "~> 1.7"
  s.add_development_dependency "appraisal"
end
