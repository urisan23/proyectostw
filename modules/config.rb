#Gemas
require 'rubygems'
require 'haml'
require 'data_mapper'
require 'erb'
require 'pony'
require 'aws/s3'

#Activa las coockies y expiran en 5 minutos
use Rack::Session::Cookie, :expire_after => 600

#Activa las coockies
configure do
  enable :sessions
end

#Subida de archivos
set :bucket, 'Proyecto PAU'
set :s3_key, 'AKIAJIJ3MM5NBA7KR3NQ'
set :s3_secret,'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'


