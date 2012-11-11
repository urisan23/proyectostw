# Define ruta de la base de datos
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/bbdd.db" )

#ESQUEMA BBDD
# Usuario -(matriculado_de)(n)-> Asignaturas
# Asignatura -(tiene)(n)-> Archivos

#Metodos:
#  -bbdd/populate_subjects
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
  has n, :subjects, :through => Resource
end

##Modelo de Asignatura
class Subject
  include DataMapper::Resource
  property :id, Serial
  property :subjectname, String
  property :course, Integer
  has n, :files, :through => Resource
end

##Modelo de Archivo de una Asignatura
class File
  include DataMapper::Resource
  property :id, Serial
  property :filename, String
end
#Actualiza los cambios
DataMapper.auto_upgrade!

get '/bbdd/populate_subjects' do
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
end
get '/bbdd/show_all' do
  haml :show_all, :locals => { :us => User.all, :sub => Subject.all, :sub_f => File.all }
end
get '/bbdd/destroy_users' do
  User.all.each{|us| us.destroy!}
end
get '/bbdd/destroy_subjects' do
  Subject.all.each{|sub| sub.destroy!}
end
