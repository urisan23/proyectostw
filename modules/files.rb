post '/upload' do
    file = params[:file]
    filename = file[:filename]
    tempfile = file[:tempfile]
    if tempfile.size > 5242880
      redirect back 
    else
      subject = Subject.get(params[:sub])
      f = Files.new
      f.filename = filename
      f.uploader = session[:current_user].username
      f.date = Time.now.to_s[0..18]
      f.size = tempfile.size
      f.calification = 0
      Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
        sftp.upload!(tempfile.path, "/proyectostw/#{filename}")
      end
      subject.filess << f
      subject.save
      f.save
      user = session[:current_user]
      user.numberFiles += 1
      redirect back
    end
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

get '/file/:s/:id' do |s, id|
  haml :file, :locals => { :sub => Subject.get(s), :file => Files.get(id)}
end

get '/file/vote/:s/:id/:stars' do |s, id, stars|
  file = Files.get(id)
  file.numberVotes += 1
  old_calification = file.calification
  file.calification = (old_calification + stars.to_i) / file.numberVotes
  file.save
  redirect "/file/#{s}/#{id}"
end
