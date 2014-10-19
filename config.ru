#### rails-rumble redirect
require 'rack-rewrite'
DOMAIN = 'www.higuys.io'
use Rack::Rewrite do
  r301 %r{.*}, "http://#{DOMAIN}$&", if: Proc.new {|rack_env|
    rack_env['SERVER_NAME'] != DOMAIN && ENV['RACK_ENV'] == "production"
  }
end
####

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
