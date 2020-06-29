require "json"

module Pdns
  # The Record object represents a single record.
  class Record
    include JSON::Serializable

    # The content of this record
    property content : String
    # Whether or not this record is disabled
    property disabled : Bool = false

    # If set to true, the server will find the matching reverse zone and create
    # a PTR there. Existing PTR records are replaced. If no matching reverse
    # Zone, an error is thrown. Only valid in client bodies, only valid for A
    # and AAAA types. Not returned by the server.
    #
    # DEPRECATED: This feature is deprecated and will be removed in 4.3.0.
    @[JSON::Field(key: "set-ptr")]
    property set_ptr : Bool?

    # Initialize a new Record with the given attributes
    #
    # ```
    # Record.new(content: "127.0.0.1", disabled: true)
    # ```
    def initialize(*, @content, @disabled = false, @set_ptr = nil)
    end

    # Initialize a new Record with the given content
    #
    # ```
    # Record.new("127.0.0.1")
    # ```
    def self.new(content : String) : self
      new(content: content, disabled: false)
    end
  end
end
