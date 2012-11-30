get '/admin' do
  haml :admin_login, :locals => { :us => session[:current_user] }
end

post '/admin' do
  if params[:password_admin].to_s == "123456"
    haml :admin, :locals => { :us => session[:current_user] }
  else
    halt 403
  end
end