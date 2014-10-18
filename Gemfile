source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.2'

gem 'airbrake'
gem 'coffee-rails'
gem 'delayed_job_active_record'
gem 'email_validator'
gem 'i18n-tasks'
gem 'jquery-rails'
gem 'pg'
gem 'rack-timeout'
gem 'rails', '4.1.6'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 4.0.3'
gem 'simple_form'
gem 'uglifier'
gem 'unicorn'
gem 'slim'

gem 'bourbon', '~> 3.2.1'
gem 'rails-assets-normalize-scss'
gem 'rails-assets-sass-list-maps'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0.0'
end

group :test do
  gem 'capybara-webkit', '>= 1.2.0'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
  gem 'webmock'
  gem 'tedium'
end

group :staging, :production do
  gem 'newrelic_rpm', '>= 3.7.3'
end

