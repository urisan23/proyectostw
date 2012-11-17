get '/inbox' do
  haml :inbox, :locals => { :us => session[:current_user]}
end
get '/message_new' do
  haml :message_new
end
post '/message_new' do

  useraux = session[:current_user]

  aux = Message.new
  aux.topic = params[:topic]
  aux.from_id = useraux.id
  aux.body = params[:body]
  aux.time = Time.now
  aux.save

  useraux.messages << aux

  session.clear
  useraux.save

  session[:current_user] = User.first(:email => useraux.email)
  session[:log] = TRUE
  redirect '/inbox'
end
