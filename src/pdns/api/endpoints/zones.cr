require "../endpoint"
require "./cryptokeys"
require "./metadata"
require "../../zone"

class Pdns::API
  module Endpoints
    class Zones < Endpoint
      # List all Zones in a server
      def list : Array(Zone)
        get("/", Array(Zone))
      end

      # Creates a new domain
      def create(zone : Zone, *, rrsets : Bool? = nil) : Zone
        post("/", Zone, body: zone, rrsets: rrsets)
      end

      # Get a zone managed by a server
      def get(id) : Zone
        get("/#{id}", Zone)
      end

      # Deletes this zone, all attached metadata and rrsets.
      def delete(id) : Nil
        delete("/#{id}", Nil)
      end

      # Creates/modifies/deletes `RRsets`
      #
      # Make sure to call `delete!` or `replace!` on existing `RRSets`
      def edit_rrsets(id) : Nil
        zone = get(id)
        rrsets = zone.rrsets || [] of RRSet

        yield rrsets

        patched_zone = Zone.new(
          name: nil,
          kind: nil,
          rrsets: rrsets.select(&.changetype)
        )
        patch("/#{id}", Nil, patched_zone)
      end

      # Modifies basic zone data (metadata).
      #
      # NOTE: Switching *dnssec* to `true` (from `false`) sets up DNSSEC
      # signing based on the other flags, this includes running the equivalent
      # of `secure-zone` and `rectify-zone` (if *api_rectify* is set to
      # `true`). This also applies to newly created zones. If *presigned* is
      # true, no DNSSEC changes will be made to the zone or cryptokeys.
      def edit_metadata(id) : Nil
        zone = get(id)
        yield zone
        patched_zone = Zone.new(
          name: nil,
          kind: zone.kind,
          masters: zone.masters,
          dnssec: zone.dnssec,
          nsec3param: zone.nsec3param,
          nsec3narrow: zone.nsec3narrow?,
          presigned: zone.presigned?,
          soa_edit: zone.soa_edit,
          soa_edit_api: zone.soa_edit_api,
          api_rectify: zone.api_rectify?,
          account: zone.account,
          nameservers: zone.nameservers,
          master_tsig_key_ids: zone.master_tsig_key_ids,
          slave_tsig_key_ids: zone.slave_tsig_key_ids,
        )

        put("/#{id}", Nil, patched_zone)
      end

      # Retrieve slave zone from its master.
      #
      # Fails when zone kind is not Slave, or slave is disabled in the
      # configuration.
      def axfr_retrieve(id)
        put("/#{id}/axfr-retrieve", String)
      end

      # Send a DNS NOTIFY to all slaves.
      #
      # Fails when zone kind is not Master or Slave, or master and slave are
      # disabled in the configuration. Only works for Slave if renotify is on.
      def notify(id)
        put("/#{id}/notify", String)
      end

      # Returns the zone in AXFR format.
      def export(id) : String
        get("/#{id}/export", String)
      end

      # Rectify the zone data.
      #
      # This does not take into account the API-RECTIFY metadata. Fails on
      # slave zones and zones that do not have DNSSEC.
      def rectify(id) : String
        put("/#{id}/rectify", String)
      end

      scoped do
        endpoint cryptokeys : Cryptokeys
        endpoint metadata : Metadata
      end
    end
  end
end
