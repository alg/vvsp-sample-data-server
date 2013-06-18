require 'sinatra'
require './src/database'
require './src/eml310_storage'

get '/voterBySSN4/' do
  search(nil, params[:lastName], params[:dobMonth], params[:dobDay], params[:dobYear], params[:ssn4], params[:localityName])
end

get '/voterByVID/' do
  search(params[:voterIDnumber], nil, nil, nil, nil, nil, params[:localityName])
end

post '/submit_eml310' do
  xml = request.env["rack.input"].read
  Eml310Storage.store(xml) unless !xml || xml.empty?
end

get '/last_eml310' do
  content_type 'text/xml'
  Eml310Storage.restore
end


def search(vid, ln, dobMonth, dobDay, dobYear, ssn4, locality)
  content_type 'text/xml'
  Database.lookup(vid, ln, dobMonth, dobDay, dobYear, ssn4, locality)
rescue Database::LookupError => e
  if defined? Thin
    Thin::HTTP_STATUS_CODES[400] = e.message
  else
    Rack::Utils::HTTP_STATUS_CODES[400] = e.message
  end

  status 400
  e.xml
end