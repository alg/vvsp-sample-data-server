require 'sinatra'
require './src/database'
require './src/eml310_storage'

get '/search/' do
  search(nil, params[:lastName], params[:dob], params[:ssn4], params[:localityName])
end

get '/:locality/:voter_id' do
  search(params[:voter_id], nil, nil, nil, params[:locality])
end

post '/submit_eml310' do
  xml = request.env["rack.input"].read
  Eml310Storage.store(xml) unless !xml || xml.empty?
end

get '/last_eml310' do
  content_type 'text/xml'
  Eml310Storage.restore
end


def search(vid, ln, dob, ssn4, locality)
  content_type 'text/xml'
  Database.lookup(vid, ln, dob, ssn4, locality)
rescue Database::LookupError => e
  if defined? Thin
    Thin::HTTP_STATUS_CODES[400] = e.message
  else
    Rack::Utils::HTTP_STATUS_CODES[400] = e.message
  end

  status 400
  e.xml
end
