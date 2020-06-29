# pdns.cr

pdns.cr provides a crystal api to interact with the JSON API of PowerDNS

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
 pdns:
   github: repomaa/pdns
```

2. Run `shards install`

## Usage

### Creating an API Instance

```crystal
require "pdns"

api = Pdns::API.new("https://your-pdns.tld", "your-api-key")
```

### Listing servers

```crystal
pp api.servers.list
```

### Listing zones on a server

```crystal
api.servers.with("localhost") do |server|
  pp server.zones.list
end
```

### Editing a zone

```crystal
api.servers.with("localhost") do |server|
  server.zones.edit_rrsets("my-domain.tld.") do |rrsets|
    # delete all CNAMEs
    rrsets.select(&.type.cname?).each(&.delete!)

    # modify a resource record set
    rrset = rrsets.find do |rrset|
      rrset.type.a? && rrset.name == "www.my-domain.tld."
    end

    raise "No such A record" if rrset.nil?

    rrset.records = [Pdns::Record.new("127.0.0.1")]
    rrset.replace!

    # add a record
    rrsets << Pdns::RRSet.new(
      name: "www.my-domain.tld.",
      type: Pdns::DNSRecordType::AAAA,
      ttl: 3600_u32,
      records: [Pdns::Record.new("::1")],
    )
  end
end
```

### Listing cryptokeys in a zone on a server

```crystal
api.servers.with("localhost") do |server|
  server.zones.with("my-domain.tld.") do |zone|
    zone.cryptokeys.list
  end
end
```

### Adding a cryptokey to a zone on a server

```crystal
api.servers.with("localhost") do |server|
  server.zones.with("my-domain.tld.") do |zone|
    key = Pdns::Cryptokey.new(
      key_type: "csk",
      bits: 256_u16
    )
    zone.cryptokeys.create(key)
  end
end
```

See [the documentation](https://repomaa.github.io/pdns.cr) for more information.
Especially the `Pdns::API::Endpoint`. Most endpoints are scoped under either
`Pdns::API::Endpoints::Servers` or `Pdns::API::Endpoints::Zones` (which is in turn
scoped under `Pdns::API::Endpoints::Servers`). You can access the scoped
endpoints by using the `#with(id)` method of an endpoint. It will be passed as a
block variable.

## Contributing

1. Fork it (<https://github.com/repomaa/pdns.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Joakim Repomaa](https://github.com/repomaa) - creator and maintainer
