# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Single sign on
gem 'devise'
gem 'omniauth'
gem 'omniauth-cas'
gem 'omniauth-rails_csrf_protection'

# ldap
gem 'net-ldap'
gem 'pagy', '< 5.0.0'

gem 'whenever'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano', require: false
  gem 'capistrano-passenger'
  gem 'capistrano-rails', require: false
  gem 'factory_bot'
  gem 'rails-controller-testing'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'bcrypt_pbkdf'
  gem 'ed25519'
  gem 'rspec-rails'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'axe-core-rspec'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'honeybadger', '~> 4.0'

gem 'flipflop', '~> 2.7'

gem 'vite_rails'

gem 'capistrano-yarn', '~> 2.0'

gem 'health-monitor-rails', '~> 12.3'
