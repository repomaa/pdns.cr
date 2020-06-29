require "../endpoint"
require "../../statistic_item"
require "../../map_statistic_item"
require "../../ring_statistic_item"

class Pdns::API
  module Endpoints
    class Statistics < Endpoint
      # Query statistics.
      #
      # Query PowerDNS internal statistics.
      #
      # *statistic* - When set to the name of a specific statistic, only this
      # value is returned. If no statistic with that name exists, the method
      # raise an error.
      #
      # *include_rings* - whether to include the Ring items, which can contain
      # thousands of log messages or queried domains. Setting this to `false`
      # may make the response a lot smaller.
      def query(
        *,
        statistic : String? = nil,
        include_rings : Bool? = nil
      ) : Array(StatisticItem|MapStatisticItem|RingStatisticItem)
        get(
          "/",
          Array(StatisticItem|MapStatisticItem|RingStatisticItem),
          statistic: statistic,
          includerings: include_rings,
        )
      end
    end
  end
end
