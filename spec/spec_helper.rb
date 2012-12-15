if ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start
end
    
require File.join(File.dirname(__FILE__), '..', 'pau.rb')
require 'sinatra'
require 'rack/test'

#entorno de pruebas
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def pau
    Sinatra::Application
end

Rspec.configure do |config|
    config.include Rack::Test::Methods
end