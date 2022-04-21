source 'https://rubygems.org'

ruby '3.1.1'

# Support PostGIS (spatial PostgreSQL extension)
gem 'activerecord-postgis-adapter'

# Remove whitespace in user-supplied data
gem 'auto_strip_attributes'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Security audit checks (eg. SQL injection)
gem 'brakeman', require: false, group: %i[development test]

# Call 'byebug' anywhere in the code to stop execution and get a debugger console
gem 'byebug', groups: %i[development test]

# Shim to load environment variables from .env into ENV in development.
gem 'dotenv-rails', groups: %i[development test]

# Dependency of RGeo operation with 'geos' library
# TODO: Remove git version once https://github.com/dark-panda/ffi-geos/issues/31 is released
gem 'ffi-geos', groups: %i[development test], git: 'https://github.com/dark-panda/ffi-geos', branch: 'homebrew'

# Replace raw numeric IDs with short unique ids
gem 'hashid-rails'

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

# RuboCop code linting
gem 'rubocop'
gem 'rubocop-performance'
gem 'rubocop-rails'
gem 'rubocop-rspec'
gem 'rubocop-thread_safety'

# RuboCop for view files
gem 'ruumba'

# Spring keeps application running in the background
gem 'spring', groups: %i[development test]

# Detect misconfigured routes
gem 'traceroute', group: %i[development test]

# Access an interactive console on exception pages or by calling 'console' anywhere in the code.
gem 'web-console', groups: :development
