#!/usr/bin/env ruby
#Gemas
require 'sinatra'
require 'haml'
require 'data_mapper'
require 'erb'
require 'rubygems'
require 'pony'
require 'net/sftp'
#Modulos de la web
require_relative 'modules/admin'
require_relative 'modules/bbdd'
require_relative 'modules/subjects'
require_relative 'modules/messages'
require_relative 'modules/files'
require_relative 'modules/error'

#Activa las coockies y expiran en 5 minutos
use Rack::Session::Cookie, :expire_after => 1800

#Activa las coockies
configure do
  enable :sessions
  # set :show_exceptions, false   #Comentar la linea para no mostrar la pagina de error y ver el fallo que da sinatra
end

#Configuración smtp
smtp_options = {:host => 'smtp.gmail.com',:port => '587',:user => 'proyectopau100@gmail.com',
                :password => 'pau123456', :auth => :plain, :tls => true }
#Variables de login
$log = FALSE
@user = nil

def gravatar_for(mail)
   gravatar_id = Digest::MD5.hexdigest(mail.downcase)
   "http://gravatar.com/avatar/#{gravatar_id}?s=300&d=mm"
end

before do
  @names = []
  User.all.each{|us|
    @names << us[:name]+" "+us[:surnames]
  }
  @user = session[:current_user]
end

get '\/' do
  if session[:log]
    redirect '/login'
  else
    redirect '/profile'
  end
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
  aux.image = gravatar_for(params[:email])
  aux.enabled = false
  aux.activation_n = ""
  10.times do 
    aux.activation_n+=rand(10).to_s()
  end
  aux.comment = ""
   Pony.mail(
     :to => "#{aux.email}",
     :from => "proyectopau100@gmail.com",
     :subject => "Bienvenido a proyecto PAU, #{aux.name}!",
     :body=>(haml :mail_welcome, :layout=>false, :locals => { :us => aux}),
     :content_type=>'text/html',
     :via => :smtp,
     :smtp => smtp_options)
  aux.password = Digest::MD5.hexdigest(aux.password)
  aux.save
  redirect '/login'
end

post '/activeaccount' do
  if params[:activation_n]=User.get(params[:user_id])
    User.get(params[:user_id]).enable = true
    session[:current_user] = User.get(params[:user_id])
    session[:log] = TRUE
    $log = TRUE
    redirect '/profile'
  end
end

get '/login' do
  session[:failed_log] = 0
  if session[:log]
    $log = TRUE
    redirect '/profile' 
  else
    haml :login, :locals => { :opc => session[:failed_log]}
  end
end

post '/login' do
  email = params[:email]
  pass = params[:password]
  user = User.first(:email => email)
  if user == nil
    user = User.first(:username => email)
  end
  if user != nil && user.enabled
    if Digest::MD5.hexdigest(pass) == user.password
      session[:current_user] = user
      session[:log] = TRUE
		  $log = TRUE
      redirect '/profile'
    else
      haml :login, :locals => { :opc => "1"}    #[usuario existe, contraseña incorrecta]   
    end
  else
    haml :login, :locals => { :opc => "2"}   #[usuario no existe]
  end
end

get '/logout' do
  $log=FALSE
  session.clear
  @user = nil
  redirect '/'
end

get '/forgotten_pass' do
  emails = []
  User.all.each{|us|
    emails << us[:email]
  }
  haml :forgotten_pass, :locals => { :used_emails => emails}
end

post '/forgotten_pass' do
  user = User.first(:email => params[:email])
  user.password=""
  6.times do 
    user.password+=rand(10).to_s()
  end
  Pony.mail(
    :to => "#{user.email}",
    :from => "proyectopau100@gmail.com",
    :subject => "Se ha generado un nuevo password",
    :body=>(haml :mail_newpass, :layout=>false, :locals => { :us => user}),
    :content_type=>'text/html',
    :via => :smtp,
    :smtp => smtp_options)
  user.password = Digest::MD5.hexdigest(user.password)
  user.save
  haml :login, :locals => { :opc => "3"}
end

get '/profile' do
  if session[:log] == nil
    redirect '/login'
    $log=FALSE
  else
    $log=TRUE
    haml :profile, :locals => { :us => session[:current_user] }
  end
end

post '/edit_profile' do
  aux = session[:current_user]
  aux.name = params[:name]
  aux.surnames = params[:surnames]
  aux.comment = params[:comment]
  aux.image = params[:image]
  if ((aux.image == "") || (aux.image==nil))
    aux.image = gravatar_for(aux.email)
  end
  session.clear
  aux.save
  session[:current_user] = User.first(:email => aux.email)
  session[:log] = TRUE
  @user = session[:current_user]
  redirect '/profile'
end

post '/change_pass' do
  aux = session[:current_user]
  session[:change_password] = FALSE
  if aux.password == Digest::MD5.hexdigest(params[:password])
    if params[:new_password] != ""
      if params[:repeat_new_password] != ""
        if params[:new_password] == params[:repeat_new_password]
          aux.password = Digest::MD5.hexdigest(params[:new_password])
          session[:change_password] = TRUE
        end
      end
    end
  end
  if session[:change_password] == FALSE
    haml :profile, :locals => { :us => session[:current_user], :o => "1"}
  else
    session.clear
    aux.save
    session[:current_user] = User.first(:email => aux.email)
    session[:log] = TRUE
    haml :profile, :locals => { :us => session[:current_user], :o => "0"}
  end
end

post '/search' do
  users_valids = []
  if params[:cadena].to_s.length > 0
    users = User.all
    users.each do |k| 
      if session[:current_user].id != k.id
        if (k.username.downcase =~ /^.*#{params[:cadena].to_s.downcase}.*$/) || 
            ((k.name + " " + k.surnames).downcase =~ /^.*#{params[:cadena].to_s.downcase}.*$/)
          users_valids << k
        end
      end
    end
  end
  haml :result_search, :locals => { :usu => users_valids}
end

get '/user/:id' do |id|
  user = User.get(id)
  haml :user, :locals => { :us => user}
end

get '/help' do
  haml :help
end

get '/contact' do
  haml :contact
end
