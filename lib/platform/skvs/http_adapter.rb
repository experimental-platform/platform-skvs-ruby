require "http"

class SKVS
  class HttpAdapter
    def url(path)
      File.join 'http://skvs', path
    end

    def get(key)
      HTTP.get(url(key)).tap do |response|
        if (200..299).include? response.status
          return JSON.load(response.body)['value']
        else
          return nil
        end
      end
    end

    def set(key, value)
      HTTP.put(url(key), form: { value: value }).tap do |response|
        return (200..299).include?(response.status)
      end
    end

    def del(key)
      HTTP.delete(url(key)).tap do |response|
        return (200..299).include?(response.status)
      end
    end
  end
end