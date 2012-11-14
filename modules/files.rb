#Subida de archivos a Amazon
set :bucket, 'Proyecto PAU'
set :s3_key, 'AKIAJIJ3MM5NBA7KR3NQ'
set :s3_secret,'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'

get '/upload' do
  haml :upload
end

post '/upload' do
  unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    return haml(:upload)
  end
  while blk = tmpfile.read(65536)
    AWS::S3::Base.establish_connection!(:access_key_id => settings.s3_key, :secret_access_key => settings.s3.secret)
    AWS::S3::S3Object.store(name, open(tmpfile), settings.bucket, :access => :public_read)
  end
  'success'
end
