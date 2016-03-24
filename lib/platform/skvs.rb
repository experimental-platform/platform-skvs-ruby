require "platform/skvs/version"
require "json"
require "platform/skvs/memory_adapter"
require "platform/skvs/http_adapter"

class SKVS
  class << self
    def adapter=(adapter)
      @adapter = adapter
    end

    def adapter
      @adapter ||= HttpAdapter.new
    end

    def get(key)
      clean adapter.get(key.to_s)
    end

    def set(key, value)
      adapter.set key.to_s, clean(value)
    end

    def try(key, value, success:, error:, sleeptime: 1)
      del success 
      del error
      original_value = get key
      set key, value

      loop do
        if message = get(success)
          return OpenStruct.new(success: message)
        elsif message = get(error)
          set key, original_value
          return OpenStruct.new(error: message)
        else
          sleep sleeptime
        end
      end
    end

    def del(key)
      adapter.del key.to_s
    end

    private 
      def clean(value)
        if value.kind_of? String and cleaned = value.strip
          cleaned
        end
      end
  end
end