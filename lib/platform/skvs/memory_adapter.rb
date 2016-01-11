class SKVS
  class MemoryAdapter
    def initialize
      @storage = Hash.new
    end

    def get(key)
      @storage[key]
    end

    def set(key, value)
      @storage[key] = value
    end

    def del(key)
      @storage.delete key
    end
  end
end