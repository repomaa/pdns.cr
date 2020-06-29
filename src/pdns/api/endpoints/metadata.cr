require "../endpoint"
require "../../metadata"

class Pdns::API
  module Endpoints
    class Metadata < Endpoint
      # Get all the Metadata associated with the zone.
      def list : Array(Pdns::Metadata)
        get("/", Array(Pdns::Metadata))
      end

      # Creates a set of metadata entries
      def create(metadata : Pdns::Metadata)
        post("/", Nil, metadata, Nil)
      end

      # Get the content of a single kind of domain metadata as a Metadata object.
      def get(kind : String) : Pdns::Metadata
        get("/#{kind}", Pdns::Metadata)
      end

      # Replace the content of a single kind of domain metadata.
      def edit(kind : String, &block : Pdns::Metadata ->) : Pdns::Metadata
        metadata = get(kind)
        yield metadata
        put("/#{kind}", Pdns::Metadata, metadata)
      end

      # Delete all items of a single kind of domain metadata.
      def delete(kind : String)
        delete("/#{kind}", String)
      end
    end
  end
end
