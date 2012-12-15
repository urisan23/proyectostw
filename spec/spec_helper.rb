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
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    def test_sign_in(user)
        controller.sign_in(user)
    end
end
