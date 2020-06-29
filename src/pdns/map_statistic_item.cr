require "json"
require "./simple_statistic_item"

module Pdns
  struct MapStatisticItem
    include JSON::Serializable

    # Item name
    getter name : String

    # set to "MapStatisticItem"
    getter type : String

    # Named values
    getter value : Array(SimpleStatisticItem)
  end
end
