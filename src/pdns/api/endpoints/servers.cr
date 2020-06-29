require "../endpoint"
require "../../server"
require "./zones"
require "./tsig_keys"
require "./searching"
require "./statistics"
require "./cache"

class Pdns::API
  module Endpoints
    class Servers < Endpoint
      def initialize(api)
        super(api, "/servers")
      end

      # List all servers
      def list : Array(Server)
        get("/", Array(Server))
      end

      # List a server
      def get(server_id : String) : Server
        get("/#{server_id}", Server)
      end

      scoped do
        endpoint zones : Zones
        endpoint tsigkeys : TSIGKeys
        endpoint search_data : Searching
        endpoint statistics : Statistics
        endpoint cache : Cache
      end
    end
  end
end
