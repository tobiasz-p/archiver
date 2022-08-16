# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'api-pagination'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'grape', '~> 1.6'
gem 'grape-entity'
gem 'haml-rails', '~> 2.0'
gem 'jbuilder', '~> 2.7'
gem 'pagy', '< 5.0.0'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4'
gem 'redis', '~> 4.0'
gem 'rubyzip'
gem 'sass-rails', '>= 6'
gem 'simple_form'
gem 'sqlite3', '~> 1.4'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry', '~> 0.13.1'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'database_cleaner-active_record'
end
