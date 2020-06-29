require "json"

module Pdns
  class Cryptokey
    include JSON::Serializable

    # set to "Cryptokey"
    getter! type : String?

    # The internal identifier, read only
    getter! id : Int32?

    @[JSON::Field(key: "keytype")]
    getter! key_type : String?

    # Whether or not the key is in active use
    getter? active : Bool

    # Whether or not the DNSKEY record is published in the zone
    getter? published : Bool?

    # The DNSKEY record for this key
    getter! dnskey : String?

    # An array of DS records for this key
    getter! ds : Array(String)?

    # The private key in ISC format
    @[JSON::Field(key: "privatekey")]
    getter private_key : String?

    # The name of the algorithm of the key, should be a mnemonic
    getter! algorithm : String?

    # The size of the key
    getter! bits : UInt16?

    def initialize(
      *,
      @key_type = nil,
      @active = true,
      @private_key = nil,
      @algorithm = nil,
      @bits = nil,
    )
    end
  end
end
