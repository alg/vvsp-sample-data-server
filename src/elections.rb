require './src/lookup_error'

class Elections

  VALID_ID = "600000000"
  INVALID  = "invalid"

  def self.by_voter(voter_id)
    if voter_id.nil?
      raise LookupError.new("Required fields absent: voterIDnumber")
    elsif voter_id !~ /^\d{9}$/
      raise LookupError.new("Invalid fields: voterIDnumber")
    else
      File.open("./data/elections/600000000.xml", "r").read
    end
  end

end
