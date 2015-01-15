source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.5'

gem 'aws-sdk'
gem 'airbrake'
gem 'coffee-rails'
gem 'delayed_job_active_record'
gem 'email_validator'
gem 'i18n-tasks'
gem 'jquery-rails'
gem 'pg'
gem 'rack-attack'
gem 'rack-timeout'
gem 'rails'
gem 'recipient_interceptor'
gem 'sass'
gem 'sass-globbing'
gem 'simple_form'
gem 'uglifier'
gem 'unicorn'
gem 'slim-rails'
gem 'pusher'
gem 'jbuilder'
gem 'responders'
gem 'omniauth'
gem 'omniauth-github'
gem 'showcase'
gem 'letter_opener'
gem 'rack-rewrite'

gem 'bourbon', '~> 3.2.1'
gem 'rails-assets-normalize-scss'
gem 'rails-assets-sass-list-maps'
gem 'rails-assets-modernizr'
gem 'rails-assets-caman'
gem 'rails-assets-momentjs'
gem 'rails-assets-jquery-tourbus'
gem 'rails-assets-headroom.js'
gem 'rails-assets-lodash'
gem 'rails-assets-jquery-cookie'

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
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'rb-inotify', require: false # linux
  gem 'rb-fsevent', require: false # os x
  gem 'vcr'
  gem 'json_spec'
end

group :test do
  gem 'poltergeist'
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
