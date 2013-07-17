class DmvDatabase

  class RecordNotFound < StandardError; end

  def self.lookup(dmv_id)
    File.open("./data/dmvid_#{dmv_id}").read
  rescue
    File.open("./data/dmvid_no_match").read
  end

end
