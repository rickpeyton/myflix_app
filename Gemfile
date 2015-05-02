source 'https://rubygems.org'
ruby '2.2.1'

gem "unicorn"
gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'bootstrap_form'
gem 'sidekiq'
gem 'carrierwave'
gem 'carrierwave-aws'
gem "mini_magick"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'dotenv-rails'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', '~> 2.8.0'
  gem 'fabrication', '~> 2.12.2'
  gem 'faker', '~> 1.4.3'
  gem 'capybara', '~> 2.4.4'
  gem 'capybara-email'
end

group :production do
  gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"
  gem 'rails_12factor'
end

