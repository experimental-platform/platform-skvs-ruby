require "spec_helper"

describe SKVS::MemoryAdapter do
  let(:adapter) { SKVS::MemoryAdapter.new }

  it "exposes a fully compatible get/set/del adapter interface" do
    adapter.set 'wat', 'lol'
    expect(adapter.get('wat')).to be == 'lol'
    adapter.del 'wat'
    expect(adapter.get('wat')).to be_nil
  end
end