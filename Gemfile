source 'https://rubygems.org'
ruby '2.1.7'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'

gem 'figaro'

# has_secure_password
gem 'bcrypt'

# Background jobs
gem 'sidekiq'
# Sinatra gem for Sidekiq Web UI
gem 'sinatra', :require => nil

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.0'
end

group :test do
  gem 'fabrication'
  gem 'faker'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner', '1.2.0'
  gem 'terminal-notifier-guard'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end

