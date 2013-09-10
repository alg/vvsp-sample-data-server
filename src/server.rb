require 'sinatra'
require './src/database'
require './src/dmv_database'
require './src/eml310_storage'
require './src/elections'
require './src/voter_admin_history'
require './src/ballot_info'

get '/voterBySSN4' do
  search(nil, params[:lastName], params[:dobMonth], params[:dobDay], params[:dobYear], params[:ssn4], params[:localityName])
end

get '/voterByVID' do
  search(params[:voterIDnumber], nil, nil, nil, nil, nil, params[:localityName])
end

post '/voterRegistrationRequest' do
  store_eml310
  'queued'
end

post '/voterRecordUpdateRequest' do
  store_eml310
  'queued'
end

get '/voterByDMVIDnumber' do
  begin
    DmvDatabase.lookup(params[:DmvIDnumber])
  rescue DmvDatabase::RecordNotFound
    <<-XML
    <VoterRegistration>
      <CheckBox type="Registered">no</CheckBox>
      <CheckBox type="DMVMatch">no</CheckBox>
    </VoterRegistration>
    XML
  end
end

get '/GetVipElectionByVoterId' do
  begin
    Elections.by_voter(params[:voterIDnumber])
  rescue LookupError => e
    send_error_400(e.message)
  end
end

get '/GetVoterTransactionLogByVoterId' do
  begin
    VoterAdminHistory.by_vid(params)
  rescue LookupError => e
    send_error_400(e.message)
  end
end

get '/GetVipBallotsByVoterId' do
  begin
    BallotInfo.by_voter(params[:VoterIDnumber], params[:electionId])
  rescue LookupError => e
    send_error_400(e.message)
  end
end

get '/last_eml310' do
  content_type 'text/xml'
  Eml310Storage.restore
end

def store_eml310
  xml = request.env["rack.input"].read
  Eml310Storage.store(xml) unless !xml || xml.empty?
end

def search(vid, ln, dobMonth, dobDay, dobYear, ssn4, locality)
  content_type 'text/xml'
  Database.lookup(vid, ln, dobMonth, dobDay, dobYear, ssn4, locality)
rescue Database::LookupError => e
  send_error_400(e.message)
  e.xml
end

def send_error_400(msg)
  if defined? Thin
    Thin::HTTP_STATUS_CODES[400] = msg
  else
    Rack::Utils::HTTP_STATUS_CODES[400] = msg
  end

  status 400
  msg
end
