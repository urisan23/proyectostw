get '/admin' do
  user = session[:current_user]
  if ((user.username == "urisan") || (user.username == "sergiojgl") || (user.username == "jjlabradorglez") || 
      (user.username == "yerayrm90") || (user.username == "thelonelywolf88"))
    haml :admin_login, :locals => { :us => session[:current_user] }
  else
    halt 403
  end
end

post '/admin' do
  if params[:password_admin].to_s == "123456"
    redirect '/admin/panel'
  else
    halt 403
  end
end

get '/admin/panel' do
  haml :admin, :locals => { :us => session[:current_user] }
end

get '/admin/users' do
  haml :admin_users
end

get '/admin/users/edit/:id' do
  user = User.first(:id => params[:id])
  haml :admin_edit_user, :locals => { :us => user }
end

post '/admin/users/admin_edit_user/:id' do
  aux = User.first(:id => params[:id])
  aux.name = params[:name]
  aux.surnames = params[:surnames]
  aux.comment = params[:comment]
  aux.image = params[:image]
  if ((aux.image == "") || (aux.image==nil))
    aux.image = gravatar_for(aux.email)
  end
  aux.save
  redirect '/admin/users'
end

get '/admin/users/delete_user/:id' do 
  user_delete = User.first(:id  => params[:id])
  user_delete.subjects.destroy!
  user_delete.messages.destroy!
  user_delete.destroy!
  redirect '/admin/users'
end

get '/admin/users/delete_user_subject/:id/:sub' do
  aux = User.first(:id => params[:id])
  aux.subjects.intermediaries.get(aux.id,Subject.all.get(params[:sub]).id).destroy!
  aux.save
  redirect "/admin/users/edit/#{params[:id]}"
end

get '/admin/subjects' do
  haml :admin_subjects
end