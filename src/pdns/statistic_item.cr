require "json"

module Pdns
  struct StatisticItem
    include JSON::Serializable

    # Item name
    getter name : String

    # set to "StatisticItem"
    getter type : String

    # Item value
    getter value : String
  end
end
