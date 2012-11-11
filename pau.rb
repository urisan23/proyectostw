#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'haml'
require 'data_mapper'
require 'erb'
require 'aws/s3'

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
end

#Actualiza los cambios
DataMapper.auto_upgrade!

#Activa las coockies
configure do
	enable :sessions
end


get '\/' do
	session[:log] = "0" if session[:log].nil?
	redirect '/login' if session[:log] == "0"
	redirect '/profile' if session[:log] == "1"
end

get '/login' do
   redirect '/profile' if session[:log] == "1"
   session[:failed_log] = 0
   haml :login, :locals => { :opc => session[:failed_log]}
end

post '/login' do
  email = params[:email]
  pass = params[:password]
  user = User.first(:email => email)
  if user != nil
    if Digest::MD5.hexdigest(pass) == User.first(:email => email).password
      session[:current_user] = User.first(:email => email)
      session[:log] = 1
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
  aux.password = Digest::MD5.hexdigest(aux.password)
  aux.save
  redirect '/login'
end

get '/profile' do
   session[:log] = "1"
   haml :profile, :locals => { :us => session[:current_user]}
end

get '/profile' do
   session[:log] = "1"
   haml :profile, :locals => { :us => session[:current_user]}
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

#Subida de archivos a Amazon
get '/upload' do
   haml :upload
end

post '/upload' do
   unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
     return haml(:upload)
   end
   while blk = tmpfile.read(65536)
      AWS::S3::Base.establish_connection!(:access_key_id => settings.s3_key, :secret_access_key => settings.s3.secret)
      AWS::S3::S3Object.store(name, open(tmpfile), settings.bucket, :access => :public_read)
   end
   'success'
end

set :bucket, 'Proyecto PAU'
set :s3_key, 'AKIAJIJ3MM5NBA7KR3NQ'
set :s3_secret,'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'


