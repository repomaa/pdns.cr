require "json"

module Pdns
  # A comment about an RRSet.
  class Comment
    include JSON::Serializable

    # The actual comment
    property content : String

    # Name of an account that added the comment
    property account : String

    # Timestamp of the last change to the comment
    @[JSON::Field(converter: Time::EpochConverter)]
    property modified_at : Time = Time.utc

    def initialize(*, @content, @account, @modified_at = Time.utc)
    end
  end
end
