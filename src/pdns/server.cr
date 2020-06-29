require "json"

module Pdns
  # Metadata of a Server
  struct Server
    include JSON::Serializable

    # Set to "Server"
    getter type : String
    # The id of the server, "localhost"
    getter id : String
    # "recursor" for the PowerDNS Recursor and "authoritative" for the Authoritative Server
    getter daemon_type : String
    # The version of the server software
    getter version : String
    # The API endpoint for this server
    getter url : String
    # The API endpoint for this server’s configuration
    getter config_url : String
    # The API endpoint for this server’s zones
    getter zones_url : String
  end
end
