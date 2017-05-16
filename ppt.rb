# require 'nombre_de_la_gema'
# declaracion de las gemas que vamos a usar en nuestra app
# notese que 'Shotgun' se instala por Rubygems pero no se declara
# en la aplicacion.
require 'rubygems'
require 'sinatra'
require 'haml'
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
class Post
  include DataMapper::Resource
  property :id, Serial
  property :titulo, String
  property :cuerpo, Text
  property :fecha, Date

  #indica que tiene varios comentarios
  has n, :comentarios

end

class Comentario
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String
  property :cuerpo, Text

  #indica que pertenece a un unico post
  belongs_to :post
end

class Visita
  include DataMapper::Resource
  property :id, Serial
  property :nombre, String
  property :mensaje, Text
  property :fecha, Date

end
Comentario.auto_upgrade!
Usuario.auto_upgrade!
Post.auto_upgrade!
Visita.auto_upgrade!

# Endpoints de nuestra app
get '/' do
  haml :index
end

get '/acerca' do
  haml :acerca
end

# accion que busca todos los Posts y nos muestra la vista que los lista
get '/posts/index' do
  @posts = Post.all
  haml :posts
end

get '/posts/ver/:id' do
  @post = Post.get(params[:id])
  haml :post
end

get '/posts/nuevo' do
  haml :post_nuevo
end

# recibe los parametros de post_nuevo
post '/posts/nuevo' do
  # crea una nueva instancia de Post con los parametros obtenidos del formulario
  post = Post.new(:titulo => params[:titulo], :cuerpo => params[:cuerpo], :fecha => Time.now)
  if post.save
    # Si el post se guarda correctamente (true), mostramos /posts
    redirect "/posts/ver/#{post.id}"
  else
    # si es false, el post no se guardo correctamente
    p 'Algo salio malo'
  end
end

post '/posts/comentarios/:post/nuevo' do
  # Buscamos el post al cual le queremos asociar el comentario, notese que lo pasamos como parametro
  post = Post.get(params[:post])

  # Creamos y populamos el comentario
  comentario = Comentario.new
  comentario.nombre = params[:nombre]
  comentario.cuerpo = params[:cuerpo]

  # Asociamos el comentario al post
  post.comentarios << comentario
  # Guardamos el post, junto con la relacion
  post.save

  redirect "/posts/ver/#{post.id}"
end

get '/visitas/index' do
  @visitas = Visita.all
  haml :visitas
end

post '/visitas/nuevo' do
  @visita = Visita.new
  @visita.nombre = params[:nombre]
  @visita.fecha = Time.now
  @visita.mensaje = params[:mensaje]

  if @visita.save
    redirect '/visitas/index'
  else
    p 'algo malo paso'
  end
end