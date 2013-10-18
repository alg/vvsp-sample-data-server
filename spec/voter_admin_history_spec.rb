require "./src/voter_admin_history"

describe VoterAdminHistory do

  it 'should return UOCAVA XML' do
    expect(VoterAdminHistory.by_vid(voterIDnumber: VoterAdminHistory::UOCAVA.first)).to \
      eq File.open("./data/voter_admin_history/uocava.xml").read
  end

  it 'should return XML' do
    expect(VoterAdminHistory.by_vid(voterIDnumber: VoterAdminHistory::VALID)).to \
      eq File.open("./data/voter_admin_history/600000000.xml").read
  end

  it 'should return no match error' do
    expect {
      VoterAdminHistory.by_vid(voterIDnumber: "000000000")
    }.to raise_error(LookupError, "No match")
  end

  it 'should return required error' do
    expect {
      VoterAdminHistory.by_vid()
    }.to raise_error(LookupError, "Required fields absent: voterIDnumber")
  end

  it 'should return invalid error' do
    expect {
      VoterAdminHistory.by_vid(voterIDnumber: 'invalid')
    }.to raise_error(LookupError, "Invalid fields: voterIDnumber")
  end

  it 'should return not available error' do
    expect {
      VoterAdminHistory.by_vid(voterIDnumber: VoterAdminHistory::NOT_AVAILABLE)
    }.to raise_error(LookupError, "Not available")
  end

  it 'should return not active error' do
    expect {
      VoterAdminHistory.by_vid(voterIDnumber: VoterAdminHistory::NOT_ACTIVE)
    }.to raise_error(LookupError, "Not active")
  end

end
