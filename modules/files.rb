require 'sinatra'
require 'net/sftp'

get '/upload' do
    haml :upload, :locals => { :opc => "0"} 
end

post '/upload' do
    file = params[:file]
    filename = file[:filename]
    tempfile = file[:tempfile]
    if tempfile.size > 5242880
      haml :upload, :locals => { :opc => "1"} 
    else
      f = Files.new
      f.filename = filename
      f.date = Time.now.to_s[0..18]
      f.size = tempfile.size
      f.calification = 0
      Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
        sftp.upload!(tempfile.path, "/proyectostw/#{filename}")
      end
      f.save
      redirect '/profile'
    end
end


get '/download' do
    haml :download
end

get '/download/:id' do |id|
    file = Files.get(id)
    tempfile = Tempfile.new("./#{file.filename}")
    Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
      sftp.download!("/proyectostw/#{file.filename}", tempfile.path)
    end
    puts tempfile.path
    send_file tempfile.path, :filename => file.filename
end
