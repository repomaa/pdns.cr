require "../endpoint"
require "../../search_result"

class Pdns::API
  module Endpoints
    class Searching < Endpoint
      # Search the data inside PowerDNS
      #
      # Search the data inside PowerDNS for *query* and return at most *max*
      # results. This includes zones, records and comments. The `*` character
      # can be used in *query* as a wildcard character and the `?` character
      # can be used as a wildcard for a single character.
      def search(
        query : String, *,
        max : Int32? = nil,
        object_type : String? = nil
      ) : Array(SearchResult)
        get("/", Array(SearchResult), q: query, max: max, object_type: object_type)
      end
    end
  end
end
