require "../endpoint"

class Pdns::API
  module Endpoints
    class Cache < Endpoint
      # Flush a cache-entry by name
      #
      # *domain*: The domain name to flush from the cache
      def flush(*, domain : String? = nil) : CacheFlushResult
        put("/flush", CacheFlushResult, nil, domain: domain)
      end
    end
  end
end
