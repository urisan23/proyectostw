get '/inbox' do
  auxid = session[:current_user].id
  session.clear
  ids = []
  User.get(auxid).messages.each{|m|
    ids << m[:to]
    ids << m[:from]
    m.read = TRUE
    m.save
  }
  User.get(auxid).save  
  ids.uniq!
  ids.delete_if {|x| x == User.get(auxid).id}
  session[:current_user] = User.get(auxid)
  haml :inbox, :locals => { :us => session[:current_user], :msgs => session[:current_user].messages, :users => User.all, :ids => ids}
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
  msg1.read = TRUE
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
  if params[:res] != nil
    redirect '/inbox'
  else
    redirect back
  end
end
get '/delete_message/:id' do|id|
  Message.get(id).destroy!
  redirect 'inbox'  
end
