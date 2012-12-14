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
  has n, :subjects, :through => Resource
  has n, :messages, :through => Resource 
end

##Modelo de Asignatura
class Subject
  include DataMapper::Resource
  property :id, Serial
  property :subjectname, String
  property :course, Integer
  has n, :filess, :through => Resource
end

##Modelo de Archivo de una Asignatura
class Files
  include DataMapper::Resource
  property :id, Serial
  property :filename, String
  property :size, String
  property :date, String
  property :calification, Integer, :default => 0
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
Subject.all.each{|aux| aux.destroy!}
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
  aux.save
  aux = User.new
  aux.name = "Sergio"
  aux.surnames = "Garcia"
  aux.email = "sergiojgl@gmail.com"
  aux.password = Digest::MD5.hexdigest("sergio 1234")
  aux.username = "sergiojgl"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("sergiojgl@gmail.com")
  aux.save
  aux = User.new
  aux.name = "Juan Jose"
  aux.surnames = "Labrador"
  aux.email = "jjlabradorglez@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "jjlabradorglez"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("jjlabradorglez@gmail.com")
  aux.save
  aux = User.new
  aux.name = "Yeray"
  aux.surnames = "Rodriguez"
  aux.email = "yerayrm90@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "yerayrm90"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("yerayrm90@gmail.com")
  aux.save
  aux = User.new
  aux.name = "Rodrigo"
  aux.surnames = "Carpintero"
  aux.email = "thelonelywolf88@gmail.com"
  aux.password = Digest::MD5.hexdigest("123456")
  aux.username = "thelonelywolf88"
  aux.comment = "Administrador del sitio"
  aux.image = gravatar_for("thelonelywolf88@gmail.com")
  aux.save
  redirect '/'
end
get '/bbdd/show_all' do
  haml :show_all, :locals => { :us => User.all, :sub => Subject.all, :sub_f => Files.all }
end
get '/bbdd/destroy_users' do
  User.all.each{|us| us.destroy!}
end
get '/bbdd/destroy_subjects' do
  Subject.all.each{|sub| sub.destroy!}
end
