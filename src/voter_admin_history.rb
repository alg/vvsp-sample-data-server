require "./src/lookup_error"

class VoterAdminHistory

  VALID         = "600000000"
  NOT_AVAILABLE = "600000001"
  NOT_ACTIVE    = "600000002"
  UOCAVA        = %w{ 600000021 600000022 600000024 600000035 600000037 600000038 600000040 600000041 600000042 600000044 600000045 600000046 600000047 600000048 }

  def self.by_vid(params = {})
    voter_id = params[:voterIDnumber]

    if UOCAVA.include?(voter_id)
      File.open("./data/voter_admin_history/uocava.xml").read
    elsif voter_id == VALID
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
