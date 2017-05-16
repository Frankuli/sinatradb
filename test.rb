# require 'nombre_de_la_gema'
# declaracion de las gemas que vamos a usar en nuestra app
# notese que 'Shotgun' se instala por Rubygems pero no se declara
# en la aplicacion.
require 'rubygems'
require 'sinatra'
require 'data_mapper'
# Inicializacion, declarando tipo y path de la base de datos
DataMapper.setup(:default, 'sqlite:db/development.db')

# Habilita un log en la consola que tenga el server corriendo de lo
# que se hace en la base de datos
DataMapper::Logger.new($stdout, :debug)

# Declaracion de clases

class Usuario
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String

end
Usuario.auto_upgrade!

# Endpoints de nuestra app
get '/' do
  haml :index
end

get '/acerca' do
  haml :acerca
end
