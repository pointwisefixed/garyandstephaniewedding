source 'https://rubygems.org'

ruby '3.3.6'

# Fix for CGI compatibility issue
gem 'cgi', '~> 0.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.7'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 4.2.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'

# Importmap for modern JavaScript
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder', '~> 2.13'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use ActiveModel has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

# React rails - modern version
gem 'react-rails', '~> 3.2'

# Bootstrap - latest version
gem 'bootstrap', '~> 5.3'

# Devise for authentication
gem 'devise', '~> 4.9'

# Excel/CSV export
gem 'csv', '~> 3.3'

# Sprockets for asset pipeline
gem 'sprockets-rails'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-rails-omakase', require: false

  # RSpec for testing
  gem 'rspec-rails', '~> 7.1'

  # Factory Bot for test data
  gem 'factory_bot_rails', '~> 6.4'

  # Faker for generating fake data
  gem 'faker', '~> 3.5'

  # Shoulda matchers for easier model testing
  gem 'shoulda-matchers', '~> 6.4'

  # RSpec JUnit formatter for CI
  gem 'rspec_junit_formatter', '~> 0.6'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console', '~> 4.2'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'

  # Better error pages
  gem 'better_errors', '~> 2.10'
  gem 'binding_of_caller', '~> 1.0'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver'

  # Code coverage
  gem 'simplecov', '~> 0.22', require: false

  # Database cleaner for tests
  gem 'database_cleaner-active_record', '~> 2.2'
end

gem "dockerfile-rails", ">= 1.7", :group => :development
