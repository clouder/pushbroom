source 'http://rubygems.org'

gem 'rails', '3.2.1'
gem 'jquery-rails'
gem 'oauth'
gem 'gmail'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :heroku do
  gem 'pg'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'capybara'
  gem 'spork', '> 0.9.0.rc'
  gem 'guard-spork'
  gem 'guard-rspec'
end

group :test, :development do
  gem 'sqlite3'
  gem "rspec-rails", "~> 2.6"
end
