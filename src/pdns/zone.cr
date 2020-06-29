require "json"
require "./rrset"

module Pdns
  # This represents an authoritative DNS Zone.
  class Zone
    include JSON::Serializable

    # Opaque zone id (string), assigned by the server,
    # should not be interpreted by the application.
    # Guaranteed to be safe for embedding in URLs.
    getter! id : String?

    # Name of the zone (e.g. "example.com.") MUST have a trailing dot
    property name : String?

    # Set to "Zone”
    property! type : String?

    # API endpoint for this zone
    property! url : String?

    # Zone kind, one of `Kind::Native`, `Kind::Master`, `Kind::Slave`
    property! kind : Kind?

    # RRSets in this zone
    # (for zones/{zone_id} endpoint only;
    # omitted during GET on the .../zones list endpoint)
    property! rrsets : Array(RRSet)?

    # The SOA serial number
    getter! serial : UInt64?

    # The SOA serial notifications have been sent out for
    getter! notified_serial : UInt64?

    # The SOA serial as seen in query responses.
    # Calculated using the SOA-EDIT metadata,
    # default-soa-edit and default-soa-edit-signed settings
    getter! edited_serial : UInt64?

    # List of IP addresses configured as a master for this zone
    # ("Slave" type zones only)
    property masters : Array(String)?

    # Whether or not this zone is DNSSEC signed
    # (inferred from presigned being true XOR presence of at least one
    # cryptokey with active being true)
    property? dnssec : Bool?

    # The NSEC3PARAM record
    property nsec3param : String?

    # Whether or not the zone uses NSEC3 narrow
    property? nsec3narrow : Bool?

    # Whether or not the zone is pre-signed
    property? presigned : Bool?

    # The SOA-EDIT metadata item
    property soa_edit : String?

    # The SOA-EDIT-API metadata item
    property soa_edit_api : String?

    # Whether or not the zone will be rectified on data changes via the API
    property? api_rectify : Bool?

    # MAY contain a BIND-style zone file when creating a zone
    property zone : String?

    # MAY be set. Its value is defined by local policy
    property account : String?

    # MAY be sent in client bodies during creation,
    # and MUST NOT be sent by the server.
    # Simple list of strings of nameserver names,
    # including the trailing dot.
    # Not required for slave zones.
    property nameservers : Array(String)?

    # The id of the TSIG keys used for master operation in this zone
    #
    # See: https://doc.powerdns.com/authoritative/tsig.html#provisioning-outbound-axfr-access
    property master_tsig_key_ids	: Array(String)?

    # The id of the TSIG keys used for slave operation in this zone
    #
    # See: https://doc.powerdns.com/authoritative/tsig.html#provisioning-signed-notification-and-axfr-requests
    property slave_tsig_key_ids	: Array(String)?

    # Initialize a new Zone with the given attributes
    #
    # ```
    # Zone.new(
    #   name: "powerdns.com.",
    #   kind: Zone::Kind::Master,
    #   rrsets: [
    #     RRSet.new(
    #       name: "www.powerdns.com.",
    #       kind: Zone::Kind::Native,
    #       type: "A",
    #       ttl: 3600_u16,
    #       changetype: "REPLACE",
    #       records: [Record.new("127.0.0.1")],
    #     ),
    #   ],
    #   soa_edit_api: "DEFAULT",
    # )
    # ```
    def initialize(
      *,
      @name,
      @kind,
      @rrsets = [] of RRSet,
      @masters = nil,
      @dnssec = nil,
      @nsec3param = nil,
      @nsec3narrow = nil,
      @presigned = nil,
      @soa_edit = nil,
      @soa_edit_api = nil,
      @api_rectify = nil,
      @zone = nil,
      @account = nil,
      @nameservers = [] of String,
      @master_tsig_key_ids = nil,
      @slave_tsig_key_ids = nil,
    )
    end

    # The kind of a Zone
    enum Kind
      Native
      Master
      Slave

      # :inherit:
      def to_json(builder : JSON::Builder)
        builder.string(to_s)
      end
    end
  end
end
