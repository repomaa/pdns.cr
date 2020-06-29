require "json"

require "./record"
require "./comment"
require "./dns_record_type"

module Pdns
  # This represents a Resource Record Set (all records with the same name and
  # type).
  class RRSet
    include JSON::Serializable

    # Name for record set (e.g. "www.powerdns.com.")
    property name : String

    # Type of this record (e.g. "A", "PTR", "MX")
    property type : DNSRecordType

    # DNS TTL of the records, in seconds.
    # MUST NOT be included when changetype is set to "DELETE”.
    property ttl : UInt32?

    # MUST be added when updating the RRSet. Must be `ChangeType::Replace` or
    # `ChangeType::Delete`.
    #
    # With `ChangeType::Delete`, all existing RRs matching name and type will
    # be deleted, including all comments.
    #
    # With `ChangeType::Replace`: when records is present, all existing RRs
    # matching name and type will be deleted, and then new records given in
    # records will be created.  If no records are left, any existing comments
    # will be deleted as well.  When comments is present, all existing comments
    # for the RRs matching name and type will be deleted, and then new comments
    # given in comments will be created.
    property changetype : ChangeType?

    # All records in this RRSet.
    #
    # When updating Records, this is the list of new records (replacing the old
    # ones). Must be empty when changetype is set to `"DELETE"`. An empty list
    # results in deletion of all records (and comments).
    property records : Array(Record)?

    # List of Comment.
    #
    # Must be empty when changetype is set to DELETE. An empty list results in
    # deletion of all comments. modified_at is optional and defaults to the
    # current server time.
    property comments : Array(Comment)?

    # Sets changetype to `ChangeType::Replace`
    def replace!
      self.changetype = ChangeType::Replace
    end

    # Sets changetype to `ChangeType::Delete`
    def delete!
      self.changetype = ChangeType::Delete
    end

    # Initialize an RRSet with the given attributes
    #
    # ```
    # RRSet.new(
    #   name: "www.powerdns.com.",
    #   type: "A",
    #   ttl: 3600_u32,
    #   records: [Record.new("127.0.0.1")],
    #   comments: [Comment.new(content: "Testing", account: "Tester")]
    # )
    # ```
    def initialize(
      *,
      @name,
      @type,
      @changetype = ChangeType::Replace,
      @ttl = nil,
      @records = nil,
      @comments = nil
    )
    end

    enum ChangeType
      Replace
      Delete

      def to_json(builder : JSON::Builder)
        builder.string(to_s.upcase)
      end
    end
  end
end
