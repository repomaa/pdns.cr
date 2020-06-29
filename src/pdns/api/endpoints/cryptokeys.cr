require "../endpoint"
require "../../cryptokey"

class Pdns::API
  module Endpoints
    class Cryptokeys < Endpoint
      # Get all CryptoKeys for a zone, except the privatekey
      def list : Array(Cryptokey)
        get("/", Array(Cryptokey))
      end

      # Creates a Cryptokey
      #
      # This method adds a new key to a zone. The key can either be generated
      # or imported by supplying the *private_key* parameter of the given
      # `Cryptokey`.
      #
      # if *private_key*, *bits* and *algorithm* aren't set, a key will be
      # generated based on the `default-ksk-algorithm` and `default-ksk-size`
      # settings for a `"ksk"` *key_type* and the `default-zsk-algorithm` and
      # `default-zsk-size` options for a `"zsk"` *key_type*.
      def create(cryptokey : Cryptokey)
        post("/", Cryptokey, cryptokey)
      end

      # This method activates a key from zone_name specified by cryptokey_id
      def activate(id : Int32)
        put("/#{id}", String, Cryptokey.new(active: true))
      end

      # This method deactivates a key from zone_name specified by cryptokey_id
      def deactivate(id : Int32)
        put("/#{id}", String, Cryptokey.new(active: false))
      end

      # This method deletes a key specified by cryptokey_id.
      def delete(id : Int32)
        delete("/#{id}", Nil)
      end

      # Returns all data about the CryptoKey, including the privatekey.
      def get(id : Int32) : Cryptokey
        get("/#{id}", Cryptokey)
      end
    end
  end
end
