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

#Activa las cockies
configure do
	enable :sessions
end


get '\/' do
	session[:log] = "0" if session[:log].nil?
	redirect '/login' if session[:log] == "0"
	redirect '/profile' if session[:log] == "1"
end

get '/login' do
   haml :login
end

post '/login' do
  #Loguear al usuario
  #if Digest::MD5.hexdigest(password_introducido) = usuario.password then login
  redirect("/profile")
end

get '/logout' do
	session.clear
	redirect '/'
end

get '/signup' do
    haml :signup
end

get '/profile' do
	session[:log] = "1"
   haml :profile
end

post '/signup' do
  aux = User.new
  aux.attributes = params
  aux.password = Digest::MD5.hexdigest(aux.password)
  aux.save
  redirect("/showall")
end

get '/showall' do
  haml :showall, :locals => { :us => User.all }
end
