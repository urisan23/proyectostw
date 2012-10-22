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
  property :surnames, String
  property :username, String
  property :email, String
  property :password, String
  property :comment, String
end

#Actualiza los cambios
DataMapper.auto_upgrade!

#Activa las coockies
configure do
  enable :sessions
end


get '\/' do
  if session[:log]
    redirect '/login'
  else
    redirect '/profile'
  end
end

get '/login' do
  session[:failed_log] = 0
  if session[:log]
    redirect '/profile' 
  else
    haml :login, :locals => { :opc => session[:failed_log]}
  end
end

post '/login' do
  email = params[:email]
  pass = params[:password]
  user = User.first(:email => email)
  if user != nil
    if Digest::MD5.hexdigest(pass) == User.first(:email => email).password
      session[:current_user] = User.first(:email => email)
      session[:log] = TRUE
      redirect '/profile'
    else
      session[:failed_log] = 1   #[usuario existe, contraseña incorrecta]   
    end
  else
    session[:failed_log] = 2   #[usuario no existe]
  end
  haml :login, :locals => { :opc => session[:failed_log]}
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/signup' do
  emails,usernames = [],[]
  User.all.each{|us|
    emails << us[:email]
    usernames << us[:username]
  }
  haml :signup, :locals => { :used_usrs => usernames, :used_emails => emails}
end

post '/signup' do
  aux = User.new
  aux.name = params[:name]
  aux.surnames = params[:surnames]
  aux.email = params[:email]
  aux.password = params[:password]
  aux.username = params[:username]
  aux.comment = ""
  aux.password = Digest::MD5.hexdigest(aux.password)
  aux.save
  redirect '/login'
end

get '/profile' do
  if session[:log] == nil
    redirect '/login'
  else
    haml :profile, :locals => { :us => session[:current_user]}
  end
end

get '/edit_profile' do
   haml :edit_profile, :locals => { :us => session[:current_user]}
end

post '/edit_profile' do
  aux = session[:current_user]
  aux.name = params[:name]
  aux.surnames = params[:surnames]
  aux.comment = params[:comment]
  if params[:password] != ""
    aux.password = Digest::MD5.hexdigest(params[:password])
  end
  session.clear
  aux.save
  session[:current_user] = User.first(:email => aux.email)
  session[:log] = TRUE
  redirect '/profile'
end

get '/showall' do
  haml :showall, :locals => { :us => User.all }
end

get '/help' do
  haml :help
end

get '/contact' do
  haml :contact
end
