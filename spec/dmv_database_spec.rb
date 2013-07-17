require './src/dmv_database'

describe DmvDatabase do

  it 'should return record' do
    expect(DmvDatabase.lookup('000000001')).to match 'SBEMatch'
  end

  it 'should return no match HTML' do
    expect(DmvDatabase.lookup('unknown')).to match 'No match'
  end

end
