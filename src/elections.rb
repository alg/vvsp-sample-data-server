require './src/lookup_error'

class Elections

  VALID_ID = "600000000"
  NO_MATCH = "000000000"
  INVALID  = "invalid"

	def self.by_voter(voter_id)
    if voter_id == VALID_ID
      File.open("./data/elections/600000000.xml", "r").read
    elsif voter_id.nil?
      raise LookupError.new("Required fields absent: voterID")
    elsif voter_id !~ /^\d{9}$/
      raise LookupError.new("Invalid fields: voterID")
    else
      raise LookupError.new("No match")
    end
	end

end