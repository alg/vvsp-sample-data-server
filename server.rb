require 'sinatra'
require './database'

get '/search/' do
  search(nil, params[:lastName], params[:dob], params[:ssn4], params[:localityName])
end

get '/:locality/:voter_id' do
  search(params[:voter_id], nil, nil, nil, params[:locality])
end

def search(vid, ln, dob, ssn4, locality)
  content_type 'text/xml'
  Database.lookup(vid, ln, dob, ssn4, locality)
rescue Database::LookupError => e
  Rack::Utils::HTTP_STATUS_CODES[400] = e.message

  if defined? Thin
    Thin::HTTP_STATUS_CODES[400] = e.message
  end

  status 400
  e.xml
end
