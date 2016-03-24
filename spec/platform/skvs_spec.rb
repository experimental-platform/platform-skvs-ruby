require 'spec_helper'

describe SKVS do
  it 'has a version number' do
    expect(SKVS::VERSION).not_to be nil
  end

  it "gives a full read/write interface for keys and values against configured adapter" do
    expect(SKVS.get('foo')).to be_nil
    expect(SKVS.set('foo', 'bar')).to be == 'bar'
    
    expect(SKVS.set('foo', 'bar')).to be == 'bar'
    expect(SKVS.del('foo')).to be_truthy
    expect(SKVS.get('foo')).to be_nil
  end

  describe ".get" do
    it "fetches the given key from the configured adapter" do
      expect(SKVS.adapter).to receive(:get).with('one').and_return('val')
      expect(SKVS.get('one')).to be == 'val'
    end

    it "converts keys to strings before querying" do
      expect(SKVS.adapter).to receive(:get).with("stringified").and_return("true")
      expect(SKVS.get(:stringified)).to be == 'true'
    end

    it "trims returned value" do
      expect(SKVS.adapter).to receive(:get).with('cleaned').and_return(" trimmed \n")
      expect(SKVS.get('cleaned')).to be == 'trimmed'
    end

    it "does not nullify returned value if empty string" do
      expect(SKVS.adapter).to receive(:get).with('presence').and_return(" \n")
      expect(SKVS.get('presence')).to be == ""
    end

    it "returns nil for missing keys" do
      expect(SKVS.adapter).to receive(:get).with('missing').and_return(nil)
      expect(SKVS.get('missing')).to be_nil
    end
  end

  describe ".set" do
    it "sets the given key in the configured adapter" do
      expect(SKVS.adapter).to receive(:set).with('one', 'val')
      SKVS.set 'one', 'val'
    end
    
    it "stringifies given key" do
      expect(SKVS.adapter).to receive(:set).with('stringified', 'key')
      SKVS.set :stringified, 'key'
    end

    it "trims given value" do
      expect(SKVS.adapter).to receive(:set).with('cleaned', "trimmed")
      SKVS.set 'cleaned', " trimmed \n"
    end
  end

  describe ".try" do
    it ".try removes given success/error keys and polls them" do
      expect(SKVS.adapter).to receive(:del).with('errorkey')
      expect(SKVS.adapter).to receive(:del).with('successkey')
      expect(SKVS.adapter).to receive(:get).with('successkey').and_return('yip')
      expect(SKVS.adapter).to receive(:get).with('foobar').and_return('original value')

      expect(SKVS.adapter).to receive(:set).with('foobar', 'baz')
      expect(SKVS.try('foobar', 'baz', success: 'successkey', error: 'errorkey').success).to be == 'yip'
    end

    it ".try restores old value on error" do
      expect(SKVS.adapter).to receive(:del).with('errorkey')
      expect(SKVS.adapter).to receive(:del).with('successkey')
      expect(SKVS.adapter).to receive(:get).with('successkey')
      expect(SKVS.adapter).to receive(:get).with('errorkey').and_return('nope')
      expect(SKVS.adapter).to receive(:get).with('foobar').and_return('original value')

      expect(SKVS.adapter).to receive(:set).with('foobar', 'baz')
      expect(SKVS.adapter).to receive(:set).with('foobar', 'original value')
      expect(SKVS.try('foobar', 'baz', success: 'successkey', error: 'errorkey').error).to be == 'nope'
    end

    it ".try retries until a response comes up" do
      expect(SKVS.adapter).to receive(:get).with('successkey')
      expect(SKVS.adapter).to receive(:get).with('errorkey')
      expect(SKVS.adapter).to receive(:get).with('successkey').and_return('yip')
      
      # Return original value
      expect(SKVS.adapter).to receive(:get).with('foobar')

      expect(SKVS.try('foobar', 'baz', success: 'successkey', error: 'errorkey', sleeptime: 0).success).to be == 'yip'
    end
  end

  describe ".del" do
    it "removes the given key in the configured adapter" do
      expect(SKVS.adapter).to receive(:del).with('one')
      SKVS.del('one')
    end
    
    it "stringifies given key" do
      expect(SKVS.adapter).to receive(:del).with('stringifed')
      SKVS.del(:stringifed)
    end
  end
end
