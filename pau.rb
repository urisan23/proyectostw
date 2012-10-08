#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'haml'
require 'data_mapper'
require 'erb'

# Define ruta de la base de datos
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/usuarios.db" )

# Define modelo de la base de datos
class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :password, String

end

#Actualiza los cambios
DataMapper.auto_upgrade!




get '/' do

end
get '/login' do
    haml :login
end
get '/signup' do
    haml :signup
end
get '/profile' do
    haml :profile
end
post '/signup' do
  aux = User.new
  aux.attributes = params
  aux.save
  redirect("/showall")
end

get '/showall' do
  haml :showall, :locals => { :us => User.all }
end


