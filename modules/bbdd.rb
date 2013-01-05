# Define ruta de la base de datos
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/bbdd.db")

#ESQUEMA BBDD
# Usuario -(matriculado_de)(n)-> Asignaturas
# Asignatura -(tiene)(n)-> Archivos

#Metodos para desarrollo:
#  -bbdd/populate
#  -bbdd/show_all
#  -bbdd/destroy_users
#  -bbdd/destroy_subjects
#

##Modelo de Usuario
class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :surnames, String
  property :username, String
  property :email, String
  property :password, String
  property :comment, String
  property :image, String, :length => 512, :default => "/img/f1.png"
  property :enabled, Boolean
  property :activation_n, String
  property :numberFiles, Integer, :default => 0
  has n, :subjects, :through => Resource
  has n, :messages, :through => Resource 
end

##Modelo de Asignatura
class Subject
  include DataMapper::Resource
  property :id, Serial
  property :subjectname, String
  property :course, Integer
  property :description, String, :default => ""
  has n, :filess, :through => Resource
  has n, :comments, :through => Resource
end

##Modelo de Archivo de una Asignatura
class Files
  include DataMapper::Resource
  property :id, Serial
  property :filename, String
  property :size, String
  property :date, String
  property :uploader, String
  property :calification, Integer, :default => 0
  property :numberVotes, Integer, :default => 0
  has n, :users, :through => Resource
end

##Modelo de Comentario
class Comment
  include DataMapper::Resource
  property :id, Serial
  property :userid, Integer
  property :text, String
  property :time, DateTime
end

##Modelo de Mensaje Privado
class Message
  include DataMapper::Resource
  property :id, Serial
  property :body, Text
  property :time, DateTime
  property :from, Integer
  property :to, Integer
  property :read, Boolean, :default => FALSE
end

#Actualiza los cambios
DataMapper.auto_upgrade!

get '/bbdd/populate' do
#BORRAR BBDD
User.all.each{|aux| 
              aux.subjects.destroy!
              aux.messages.destroy!
              aux.destroy!}
Subject.all.each{|aux| 
                 aux.filess.destroy!
                 aux.destroy!}
User.all.each{|aux| aux.destroy!}
Files.all.each{|aux| aux.destroy!}
#SUBJECTS
  primero = ["Informatica Basica","Algebra","Calculo","Fundamentos Fisicos para la Ingenieria","Organizaciones Empresariales","Algoritmos y Estructura de Datos","Principios de Computadores","Optimizacion","Sistemas Electronicos Digitales","Expresion Grafica en Ingenieria"]
  segundo = ["Estadistica","Computabilidad y Algoritmia","Estructura de Computadores","Sistemas Operativos","Ingles Tecnico","Algoritmos y Estructura de Datos Avanzados","Redes y Sistemas Distribuidos","Administracion de Sistemas","Fundamentos de Ingenieria del Software","Codigo Deontologico y Aspectos Legales"]
  tercero = ["Procesadores de Lenguajes","Diseno y Analisis de Algoritmos","Program. de Aplicaciones Interactivas","Inteligencia Artificial Avanzada","Tratamiento Inteligente de Datos","Diseno de Procesadores","Arquitectura de Computadores","Redes de Computadores","Laboratorio de Redes","Sistemas Operativos Avanzados","Modelado de Sistemas de Software","Analisis de Sistemas de Software","Modelado de Datos","Gestion de Riesgos","Gestion de la Calidad","Control de Calidad","Sistemas de Informacion para las Organizaciones","Seguridad en Sistemas Informaticos","Desarrollo de Sistemas Informaticos","Usabilidad y Accesibilidad"]
  cuarto = ["Inteligencia Emocional","Practicas Externas","Trabajo de fin de grado","Interfaces Inteligentes","Sistemas Inteligentes","Complejidad Computacional","Sistemas Empotrados","Arquitecturas Avanzadas y de Proposito Especifico","Seguridad de Sistemas Informaticos","Laboratorio de desarrollo y herramientas","Normativa y Regulacion","Diseno Arquitectonico y Patrones","Sistemas de Informacion Contable","Gestion de la Innovacion","Desarrollo y Mantenimiento de Sistemas de Informacion","Tecnologias de la Informacion para las Organizaciones","Sistemas y Tecnologias Web","Gestion del Conocimiento en las Organizaciones","Administracion y Diseno de Bases de Datos","Vision Por Computador","Ingenieria Logistica","Robotica Computacional"]
  primero.each{|sub|
    subject = Subject.new()
    subject.subjectname = sub
    subject.course = 1
    subject.save
  }
  segundo.each{|sub|
    subject = Subject.new()
    subject.subjectname = sub
    subject.course = 2
    subject.save
  }
  tercero.each{|sub|
    subject = Subject.new()
    subject.subjectname = sub
    subject.course = 3
    subject.save
  }
  cuarto.each{|sub|
    subject = Subject.new()
    subject.subjectname = sub
    subject.course = 4
    subject.save
  }
#USER (añade el tuyo)
  aux = User.new
  aux.name = "Uriel"
  aux.surnames = "Sanchez"
  aux.email = "urisan91@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "urisan"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("urisan91@gmail.com")
  aux.enabled = true
  aux.save
  aux = User.new
  aux.name = "Sergio"
  aux.surnames = "Garcia"
  aux.email = "sergiojgl@gmail.com"
  aux.password = Digest::MD5.hexdigest("sergio 1234")
  aux.username = "sergiojgl"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("sergiojgl@gmail.com")
  aux.enabled = true
  aux.save
  aux = User.new
  aux.name = "Juan Jose"
  aux.surnames = "Labrador"
  aux.email = "jjlabradorglez@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "jjlabradorglez"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("jjlabradorglez@gmail.com")
  aux.enabled = true
  aux.save
  aux = User.new
  aux.name = "Yeray"
  aux.surnames = "Rodriguez"
  aux.email = "yerayrm90@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "yerayrm90"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("yerayrm90@gmail.com")
  aux.enabled = true
  aux.save
  aux = User.new
  aux.name = "Rodrigo"
  aux.surnames = "Carpintero"
  aux.email = "thelonelywolf88@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "thelonelywolf88"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("thelonelywolf88@gmail.com")
  aux.enabled = true
  aux.save
  redirect '/admin/panel'
end

get '/bbdd/show_all' do
  if session[:current_user] != nil
    user = session[:current_user]
    if ((user.username == "urisan") || (user.username == "sergiojgl") || (user.username == "jjlabradorglez") || 
        (user.username == "yerayrm90") || (user.username == "thelonelywolf88"))
      haml :show_all, :locals => { :us => User.all, :sub => Subject.all, :sub_f => Files.all }
    else
      halt 403
    end
  else
    halt 403
  end
end

get '/bbdd/destroy_users' do
  User.all.each{|us|
                us.subjects.destroy!
                us.messages.destroy!
                us.destroy!}
  redirect '/admin/users'
end

get '/bbdd/destroy_subjects' do
  Subject.all.each{|sub| 
                   sub.filess.destroy!
                   sub.destroy!}
  redirect '/admin/subjects'
end

get '/bbdd/destroy_files' do
  Files.all.each{|file| file.destroy!}
  redirect '/admin/files'
end
