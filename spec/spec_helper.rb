$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'ostruct'
require 'platform-skvs'

RSpec.configure do |config|
  config.before(:each) do
    SKVS.adapter = SKVS::MemoryAdapter.new
  end
end