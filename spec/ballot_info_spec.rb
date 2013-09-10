require './src/ballot_info'

describe BallotInfo do

  describe 'error reporting' do
    it 'should report missing fields' do
      expect {
        BallotInfo.by_voter(nil, nil)
      }.to raise_error(LookupError, 'Required fields absent: VoterIDnumber, electionId')
    end

    it 'should report invalid fields' do
      expect {
        BallotInfo.by_voter('a', 'b')
      }.to raise_error(LookupError, 'Invalid fields: VoterIDnumber, electionId')
    end
  end

  it 'should return XML for valid data' do
    expect(BallotInfo.by_voter('123456789', '12345678-1234-1234-1234-123456789012')).to \
      eq File.open("./data/ballot_data_example.xml").read
  end
end
