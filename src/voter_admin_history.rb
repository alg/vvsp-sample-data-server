require "./src/lookup_error"

class VoterAdminHistory

  VALID         = "600000000"
  NOT_AVAILABLE = "600000001"
  NOT_ACTIVE    = "600000002"

  def self.by_vid(params = {})
    voter_id = params[:voterIDnumber]

    if voter_id == VALID
      File.open("./data/voter_admin_history/600000000.xml").read
    elsif voter_id.nil?
      raise LookupError.new("Required fields absent: voterIDnumber")
    elsif voter_id !~ /^\d{9}$/
      raise LookupError.new("Invalid fields: voterIDnumber")
    elsif voter_id == NOT_AVAILABLE
      raise LookupError.new("Not available")
    elsif voter_id == NOT_ACTIVE
      raise LookupError.new("Not active")
    else
      raise LookupError.new("No match")
    end
  end

end
