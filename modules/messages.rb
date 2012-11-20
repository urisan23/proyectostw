get '/inbox' do
  haml :inbox, :locals => { :us => session[:current_user], :msgs => session[:current_user].messages}
end

post '/send_message/:id' do|id|
  sender = session[:current_user]
  receiver = User.get(id)
  session.clear

  msg1 = Message.new
  msg1.body = params[:body]
  msg1.from = sender.id
  msg1.to = receiver.id
  msg1.time = Time.now
  msg1.save
  msg2 = Message.new
  msg2.body = params[:body]
  msg2.from = sender.id
  msg2.to = receiver.id
  msg2.time = Time.now
  msg2.save

  sender.messages << msg1
  sender.save
  receiver.messages << msg2
  receiver.save

  session[:current_user] = User.first(:email => sender.email)
  session[:log] = TRUE
  redirect '/profile'
end
