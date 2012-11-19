require './src/eml310_storage'
class PseudoRedis

  def initialize
    @data = {}
  end

  def set(key, val)
    @data[key] = val
  end

  def get(key)
    @data[key]
  end

end

describe Eml310Storage do

  let(:redis) { PseudoRedis.new }
  let(:data) { "xml data" }

  before { Eml310Storage.stub(redis: redis) }

  it 'should store data' do
    Eml310Storage.store(data)
    Eml310Storage.restore.should == data
  end

end
