require "json"

module Pdns
  # A TSIG key that can be used to authenticate NOTIFYs and AXFRs
  class TSIGKey
    include JSON::Serializable

    # The name of the key
    property name : String

    # The ID for this key, used in the TSIGkey URL endpoint.
    getter! id : String?

    # The algorithm of the TSIG key
    property algorithm : String

    # The Base64 encoded secret key, empty when listing keys. MAY be empty when
    # POSTing to have the server generate the key material
    property key : String?

    # Set to "TSIGKey"
    getter! type : String?

    def initialize(*, @name, @algorithm)
    end
  end
end
