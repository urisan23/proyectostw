require 'sinatra'
require 'dropbox_sdk'
require 'dropbox'

#session = nil
appkey = 'mzcs7bxj6rj08nc'
appsecret = '7ji6lgx5scg4l7n'
accesstype = :app_folder

get '/oauth' do
    dbsession = DropboxSession.new(appkey, appsecret)
    dbsession.get_request_token
    session[:request_db_session] = dbsession.serialize
    authorize_url = dbsession.get_authorize_url(ENV['CALLBACK_URL'] || 'http://localhost:4567/done')
    redirect authorize_url
end

get '/done' do
    dbsession = DropboxSession.deserialize(session[:request_db_session])
    
    dbsession.get_access_token
    session[:authorized_db_session] = dbsession.serialize

    redirect '/upload'
end

get '/upload' do
    if session[:authorized_db_session]
        haml :upload
    else
        redirect '/oauth'
    end
end

post '/upload' do
    dbsession = DropboxSession.deserialize(session[:authorized_db_session])
    client = DropboxClient.new(dbsession, accesstype)
    file = params[:file]
    filename = file[:filename]
    tempfile = file[:tempfile]
    
    puts session.inspect
    response = client.put_file("/#{filename}", tempfile.read)
    redirect '/profile'
end


get '/download' do
    if session[:authorized_db_session]
        haml :download
    else
        redirect '/oauth'
    end
end

post '/download' do
    dbsession = DropboxSession.deserialize(session[:authorized_db_session])
    client = DropboxClient.new(dbsession, accesstype)
    file = params[:file]
    
    link = client.media("/#{file}")
    redirect link["url"]+"?dl=1"
end
