require "json"

module Pdns
  struct SearchResult
    include JSON::Serializable

    getter content : String?
    getter? disabled : Bool?
    getter name : String
    getter object_type : ObjectType
    getter zone_id : String
    getter zone : String?
    getter type : String?
    getter ttl : UInt32?

    enum ObjectType
      Record
      Zone
      Comment
    end
  end
end
