require "json"
require "./simple_statistic_item"

module Pdns
  struct RingStatisticItem
    include JSON::Serializable

    # Item name
    getter name : String

    # set to "RingStatisticItem"
    getter type : String

    # Ring size
    getter size : UInt32

    # Named values
    getter value : Array(SimpleStatisticItem)
  end
end
