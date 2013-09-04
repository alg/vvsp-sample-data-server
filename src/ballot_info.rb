require './src/lookup_error'

class BallotInfo

  def self.by_voter(voter_id, election_uid)
    missing_fields = []
    missing_fields << 'voterID' if voter_id.nil?
    missing_fields << 'electionUID' if election_uid.nil?
    raise LookupError.new("Required fields absent: #{missing_fields.join(', ')}") unless missing_fields.empty?

    invalid_fields = []
    invalid_fields << 'voterID' if voter_id !~ /^\d{9}$/
    invalid_fields << 'electionUID' if election_uid !~ /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
    raise LookupError.new("Invalid fields: #{invalid_fields.join(', ')}") unless invalid_fields.empty?

    File.open("./data/ballot_data_example.xml").read
  end

end
