require "json"

module Pdns
  # Represents zone metadata
  class Metadata
    include JSON::Serializable

    # Name of the metadata
    getter kind : String

    # Array with all values for this metadata kind.
    getter metadata : Array(String)
  end
end
