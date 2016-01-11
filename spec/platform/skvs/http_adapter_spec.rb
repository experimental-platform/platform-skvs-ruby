require 'spec_helper'

describe SKVS::HttpAdapter do
  let(:adapter) { SKVS::HttpAdapter.new }

  def http_response(status: 200, value: "", error: nil)
    OpenStruct.new(status: status, body: JSON.dump(value: value, error: error))
  end

  describe "#get" do
    it "fetches the value for given key from skvs http interface" do
      expect(HTTP).to receive(:get).with('http://skvs/mykey').and_return(http_response(value: 'foo'))
      expect(adapter.get('mykey')).to be == 'foo'
    end
    
    it "returns nil when given key is missing" do
      expect(HTTP).to receive(:get).with('http://skvs/nokey').and_return(http_response(status: 404))
      expect(adapter.get('nokey')).to be_nil
    end
  end

  describe "#set" do
    it "stores the given key using http" do
      expect(HTTP).to receive(:put).with('http://skvs/mykey', form: { value: 'foobar' }).and_return(http_response)
      expect(adapter.set('mykey', 'foobar')).to be == true
    end
  end

  describe "#del" do
    it "returns true when key was deleted successfully" do
      expect(HTTP).to receive(:delete).with('http://skvs/mykey').and_return(http_response)
      expect(adapter.del('mykey')).to be == true
    end

    it "returns false when key to be deleted does not exist" do
      expect(HTTP).to receive(:delete).with('http://skvs/nokey').and_return(http_response(status: 404))
      expect(adapter.del('nokey')).to be == false
    end
  end
end
