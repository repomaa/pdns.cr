require "../endpoint"
require "../../tsig_key"

class Pdns::API
  module Endpoints
    class TSIGKeys < Endpoint
      # Get all TSIG Keys on the server, except the actual key
      def list : Array(TSIGKey)
        get("/", Array(TSIGKey))
      end

      # Add a TSIG key
      #
      # This methods add a new TSIG Key. The actual key can be generated by the
      # server or be provided by the client
      def create(key : TSIGKey) : TSIGKey
        post("/", TSIGKey)
      end

      # Get a specific TSIG Key on the server, including the actual key
      def get(id : String) : TSIGKey
        get("/#{id}", TSIGKey)
      end

      # Edit a TSIG Key
      def edit(id : String) : TSIGKey
        key = get(id)
        yield key
        put("/#{id}", TSIGKey, key)
      end

      # Delete the TSIG Key with *id*
      def delete(id : String)
        delete("/#{id}", Nil)
      end
    end
  end
end
