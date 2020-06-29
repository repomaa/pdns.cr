require "json"

module Pdns
  # The result of a cache-flush
  struct CacheFlushResult
    include JSON::Serializable

    # Amount of entries flushed
    getter count : UInt64

    # A message about the result like "Flushed cache"
    getter result : String
  end
end
