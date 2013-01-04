get '/subjects' do
  haml :subjects, :locals => { :sub => Subject.all, :us => session[:current_user]}
end

get '/register/:sub' do|sub|
  aux = session[:current_user]
  aux.subjects << Subject.get(sub)
  session.clear
  aux.save
  session[:current_user] = User.first(:email => aux.email)
  session[:log] = TRUE
  redirect back
end

get '/unregister/:sub' do|sub|
  aux = session[:current_user]
  aux.subjects.intermediaries.get(aux.id,Subject.all.get(sub).id).destroy!
  session.clear
  aux.save
  session[:current_user] = User.first(:email => aux.email)
  session[:log] = TRUE
  redirect back
end

get '/subjects/:idsub' do|idsub|
  haml :subject, :locals => { :sub => Subject.get(idsub), :users => User.all, :opc => "0"}
end
post '/subjects/:idsub' do|idsub|
  comment = Comment.new
  subject = Subject.get(idsub)
  comment.text = params[:text]
  comment.userid = session[:current_user].id
  comment.time = Time.now
  subject.comments << comment
  subject.save
  comment.save
  haml :subject, :locals => { :sub => Subject.get(idsub), :users => User.all, :opc => "0"}
end
