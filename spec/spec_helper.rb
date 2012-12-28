if ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start
end
    
require File.join(File.dirname(__FILE__), '..', 'pau.rb')
require 'sinatra'
Sinatra::Application.environment = :test
Bundler.require :default, Sinatra
require 'rspec'
require 'rack/test'

#entorno de pruebas
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def pau
    Sinatra::Application
end

Sinatra::Application.default_options.merge!(
    :env => :test,
    :run => false,
    :raise_errors => true,
    :logging => false
)

Rspec.configure do |config|
    config.include Rack::Test::Methods
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    def test_sign_in(user)
        controller.sign_in(user)
    end
end
