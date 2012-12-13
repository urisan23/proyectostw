require 'sinatra'
require 'net/sftp'

get '/upload' do
    haml :upload
end

post '/upload' do
    file = params[:file]
    puts file.class
    filename = file[:filename]
    tempfile = file[:tempfile]
    f = Files.new
    f.filename = filename
    f.date = Time.now.to_s[0..18]
    f.size = tempfile.size
    f.calification = 0
    puts "#{filename}"
    puts "#{tempfile.path}"
    Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
      sftp.dir.foreach("/proyectostw/") do |entry|
        puts entry.longname
      end
      sftp.upload!(tempfile.path, "/proyectostw/#{filename}")
    end
    f.save
    redirect '/profile'
end


get '/download' do
    haml :download
end

# post '/download' do
#     dbsession = DropboxSession.deserialize(session[:authorized_db_session])
#     client = DropboxClient.new(dbsession, accesstype)
#     file = params[:file]
#     
#     link = client.media("/#{file}")
#     redirect link["url"]+"?dl=1"
# end
