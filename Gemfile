# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bunny', '>= 2.9.2'
gem 'coffee-rails', '~> 4.2'
gem 'faraday'
gem 'faraday_middleware'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.5'
gem 'sass-rails', '~> 5.0'
gem 'sneakers'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'bunny-mock', require: false
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
end

gem 'tzinfo-data'
