require 'simplecov'
SimpleCov.start do
    add_filter '/spec/'
    add_filter '/public/'
    add_filter '/coverage/'
    
    add_group 'Modules', 'modules'
    add_group 'Views', 'views'
end
    
require File.join(File.dirname(__FILE__), '..', 'pau.rb')
require 'rubygems'
require 'sinatra'
require 'rspec'
require 'rack/test'

Sinatra::Application.environment = :test
#Bundler.require :default, Sinatra

#entorno de pruebas
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

module TestMethods
    def app
        Sinatra::Application
    end
end
    
#Sinatra::Application.default_options.merge!(
#    :env => :test,
#    :run => false,
#    :raise_errors => true,
#    :logging => false
#)

Rspec.configure do |config|
    config.include Rack::Test::Methods
    config.include TestMethods
    config.before(:each) { DataMapper.auto_migrate! }
    #DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bbdd.db")
    #DataMapper.finalize
    #Post.auto_migrate!
    #Tag.auto_migrate!
    #config.use_transactional_fixtures = true
    #config.infer_base_class_for_anonymous_controllers = false


    #def test_sign_in(user)
    #    controller.sign_in(user)
    #end
end
