require './src/elections'

describe Elections do

  describe 'by_voter' do
    it 'should return XML' do
      expect(Elections.by_voter(Elections::VALID_ID)).to eq File.open("./data/elections/600000000.xml", "r").read
    end

    it 'should return not found error' do
      expect {
        Elections.by_voter(Elections::NO_MATCH)
      }.to raise_error(LookupError, "No match")
    end

    it 'should return invalid error' do
      expect {
        Elections.by_voter(Elections::INVALID)
      }.to raise_error(LookupError, "Invalid fields: voterIDnumber")
    end

    it 'should return absent error' do
      expect {
        Elections.by_voter(nil)
      }.to raise_error(LookupError, "Required fields absent: voterIDnumber")
    end
  end

end
