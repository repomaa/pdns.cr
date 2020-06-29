require "json"

module Pdns
  struct SimpleStatisticItem
    include JSON::Serializable

    # Item name
    getter name : String

    # Item value
    getter value : String
  end
end
