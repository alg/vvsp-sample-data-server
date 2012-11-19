require 'json'
require 'redis'

class Eml310Storage

  # Stores EML in the database
  def self.store(eml)
    redis.set('latest-eml', eml)
  end

  # Gets the EML from the database
  def self.restore
    redis.get('latest-eml')
  end

  private

  def self.redis(uri = ENV["REDISTOGO_URL"])
    uri = URI.parse(uri)
    @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

end
