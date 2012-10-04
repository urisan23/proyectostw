#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'haml'
require 'data_mapper'
require 'erb'

# Define ruta de la base de datos
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/agenda.db" )

# Define modelo de la base de datos
class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :email, String

end

#Actualiza los cambios
DataMapper.auto_upgrade!




get '/' do
    haml :index
end

