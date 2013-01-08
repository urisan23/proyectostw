not_found do
  redirect '/errors/404/404.html'
end

error 404 do
  redirect '/errors/404/404.html'
end

error 400..403 do
  redirect '/errors/403/403.html'
end

error 500..510 do
  'Internal Server Error'
end
