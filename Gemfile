source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Support PostGIS (spatial PostgreSQL extension)
gem 'activerecord-postgis-adapter'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Security audit checks (eg. SQL injection)
gem 'brakeman', require: false, group: %i[development test]

# Call 'byebug' anywhere in the code to stop execution and get a debugger console
gem 'byebug', groups: [:development, :test]

# Shim to load environment variables from .env into ENV in development.
gem 'dotenv-rails', groups: [:development, :test]

# Dependency of RGeo operation with 'geos' library
gem 'ffi-geos', groups: [:development, :test]

# JSON APIs
gem 'jbuilder'

# Listener for filesystem changes
gem 'listen', groups: %i[development test]

# PostgreSQL database wrapper
gem 'pg'

# Puma app server
gem 'puma'

# Ruby on Rails Framework!
gem 'rails'

# Render RGeo (from PostGis) as GeoJSON
gem 'rgeo-geojson'

# RSpec test framework
gem 'rspec-rails', groups: %i[development test]

# Spring keeps application running in the background
gem 'spring', groups: %i[development test]

# Detect misconfigured routes
gem 'traceroute', group: %i[development test]

# Access an interactive console on exception pages or by calling 'console' anywhere in the code.
gem 'web-console', groups: :development
