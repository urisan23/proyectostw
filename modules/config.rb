#Gemas
require 'rubygems'
require 'haml'
require 'data_mapper'
require 'erb'
require 'pony'

#Activa las coockies y expiran en 5 minutos
use Rack::Session::Cookie, :expire_after => 1800

#Activa las coockies
configure do
  enable :sessions
end


