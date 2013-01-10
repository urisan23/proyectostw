def filetype (filename)
  ext = File.extname(filename)[1..-1].downcase
  type = ""
  if ext =~ /txt|calendar|css|csv|dns|example|html|rtf|rtx|vcard|vnd|xml|js|sgml|cpp|c|h|hpp|html|pas|java|php|py|h.*/
    type = "text/#{ext}"
  elsif ext =~ /exe|bin|msi|doc|ppt|xls|pptx|doxx|xlsx|odt|ods|odx|pdf/
    type = "application/#{ext}"
  elsif ext =~ /mp3|mid|midi|wav|wma|cda|ogg|ogm|aac|ac3|flac/
    type = "audio/#{ext}"
  elsif ext =~ /3gp|3g2|asf|mov|avi|vob|flv|as|mpg|mp4|rm|f4v|swf|srt|wmv|bik|mod|mk|divx|h26.*/
    type = "video/#{ext}"
  elsif ext =~ /bmp|dds|gif|jpg|png|psd.*|tga|thm|tif|tiff|yuv|abm|afx|jpeg/
    type = "image/#{ext}"
  elsif ext =~ /iges|mesh|vnd\.?.*|vrml/
    type = "model/#{ext}"
  elsif ext =~ /alternative|appledouble|byteranges|digest|encrypted|example|form\-data|header\-set|mixed|parallel|related|report|signed/
    type = "multipart/#{ext}"
  else
    type = "BIN"
  end
  type
end

def read (id)
  file = Files.get(id)
  tempfile = Tempfile.new("./#{file.filename}")
  Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
    sftp.download!("/proyectostw/#{file.filename}", tempfile.path)
  end
  contents = ""
  tempfile.each {|line|
    contents << line
  }
  contents
end

def extension (filename)
  File.extname(filename)[1..-1].downcase
end

GIGA_SIZE = 1073741824.0
MEGA_SIZE = 1048576.0
KILO_SIZE = 1024.0

def hrsize(size, precision)
  if size == 1
    "1 Byte"
  elsif size < KILO_SIZE  
    "%d Bytes" % size
  elsif size < MEGA_SIZE  
    "%.#{precision}f KB" % (size / KILO_SIZE)
  elsif size < GIGA_SIZE  
    "%.#{precision}f MB" % (size / MEGA_SIZE)
  else 
    "%.#{precision}f GB" % (size / GIGA_SIZE)
  end
end

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
      Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
        sftp.upload!(tempfile.path, "/proyectostw/#{filename}")
      end
      subject.filess << f
      subject.save
      f.save
      redirect back
    end
end

get '/download/:id' do |id|
    file = Files.get(id)
    tempfile = Tempfile.new("./#{file.filename}")
    Net::SFTP.start('193.145.101.220', 'root', :password => 'sanandreS12') do |sftp|
      sftp.download!("/proyectostw/#{file.filename}", tempfile.path)
    end
    ext = filetype(file.filename)
    send_file tempfile.path, :filename => file.filename, :type => ext
end

get '/file/:s/:id' do |s, id|
  ids = []
  Files.get(id).votes.each{|v|
    ids << v.userid
  }
  haml :file, :locals => { :sub => Subject.get(s), :file => Files.get(id),:us => session[:current_user]}
end

get '/file/vote/:s/:id/:stars' do |s, id, stars|
  votonuevo = false
  file = Files.get(id)
  vote = file.votes.first(:userid => session[:current_user].id)
  if vote == nil
    vote = Vote.new
    votonuevo = true
  end
  vote.userid = session[:current_user].id
  vote.value = stars
  if votonuevo
    file.votes << vote
  end
  vote.save
  file.save
  redirect "/file/#{s}/#{id}"
end
