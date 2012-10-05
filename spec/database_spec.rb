require './database'

describe Database do

  it 'should return the record by vid and locality' do
    r = Database.lookup('600000000', '', '', '', 'noRfolk city')
    r.should include "FRANKIE"
  end

  it 'should return the record by ssn4' do
    r = Database.lookup('', 'KEck', '07/05/1939', '0003', 'lOuDoUn COUNTY')
    r.should include "21543 Welby Ter"
  end

  it 'should report confidentiality' do
    lambda {
      Database.lookup('600000009', '', '', '', 'newport news city')
    }.should raise_error Database::LookupError, Database::ERRORS[:confidential]
  end

  it 'should report inactivity' do
    lambda {
      Database.lookup('600000011', '', '', '', 'harrisonburg city')
    }.should raise_error Database::LookupError, Database::ERRORS[:inactive]
  end

  it 'should report missing record' do
    r = Database.lookup('600000011', '', '', '', 'harrisonburg')
    r.should include 'not found'
  end

end
