class SKVS
  class MemoryAdapter
    def initialize
      @storage = Hash.new
    end

    def get(key)
      if @storage.has_key? key
        @storage[key]
      end
    end

    def set(key, value)
      @storage[key] = value
    end

    def del(key)
      @storage.delete key
    end
  end
end