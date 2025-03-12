# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'active_interaction'
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.2'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv', '>= 3.0'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rswag', '~> 2.13'
end

group :development do
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end
