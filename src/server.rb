require 'sinatra'
require './src/database'
require './src/eml310_storage'

get '/voterBySSN4/' do
  search(nil, params[:lastName], params[:dobMonth], params[:dobDay], params[:dobYear], params[:ssn4], params[:localityName])
end

get '/voterByVID/' do
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
  if params[:DMVIDnumber].size == 12
    <<-XML
    <VoterRegistration>
      <CheckBox type="Registered">yes</CheckBox>
      <CheckBox type="DMVMatch">no</CheckBox>
    </VoterRegistration>
    XML
  elsif params[:DMVIDnumber].size == 9
    <<-XML
    <VoterRegistration>
      <CheckBox type="Registered">no</CheckBox>
      <CheckBox type="DMVMatch">yes</CheckBox>
      <ElectoralAddress>
        <FreeTextAddress>
          <AddressLine type="AddressLine1" seqn="1">2228 MCKANN AVE</AddressLine>
          <AddressLine type="AddressLine2" seqn="2">APT 12</AddressLine>
          <AddressLine type="City" seqn="3">NORFOLK</AddressLine>
          <AddressLine type="State" seqn="4">VA</AddressLine>
          <AddressLine type="Zip" seqn="5">235092235</AddressLine>
          <AddressLine type="Country" seqn="6"/>
          <AddressLine type="Jurisdiction" seqn="7">NORFOLK CITY</AddressLine>
        </FreeTextAddress>
      </ElectoralAddress>
    </VoterRegistration>
    XML
  else
    <<-XML
    <VoterRegistration>
      <CheckBox type="Registered">no</CheckBox>
      <CheckBox type="DMVMatch">no</CheckBox>
    </VoterRegistration>
    XML
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
  if defined? Thin
    Thin::HTTP_STATUS_CODES[400] = e.message
  else
    Rack::Utils::HTTP_STATUS_CODES[400] = e.message
  end

  status 400
  e.xml
end
