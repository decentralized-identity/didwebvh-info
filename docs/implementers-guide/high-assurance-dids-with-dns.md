# Using High Assurance DIDs with DNS

The [High Assurance DIDs with DNS] mechanism that can be used with `did:web`
applies equally well with `did:webvh`.  A DID Controller publishing a
`did:webvh` could use the mechanisms defined in the [High Assurance DIDs with DNS]
specification despite `did:webvh` DIDs not (yet) being explicitly called out in
the [High Assurance DIDs with DNS] specification. In particular, as `did:webvh`
uses the same DID-to-HTTP transformation, publishing the expected DNS Domain
records, and adding the required verification method and Data Integrity
proof to their DIDDoc is done as defined in the [High Assurance DIDs
with DNS] specification. Likewise, a resolver can include code to check to see if
the DID Controller published the [High Assurance DIDs with DNS]
specification DNS records and use those to further verify the DID.

[High Assurance DIDs with DNS]: https://www.ietf.org/archive/id/draft-carter-high-assurance-dids-with-dns-03.html

Alternatively, since `did:webvh` is not mentioned in the [High Assurance DIDs with
DNS] specification, a `did:webvh` DID Controller could use the "not `did:web`"
technique described in that specification and include a `dnsValidationDomain`
entry in the DIDDoc to explicitly denote where to find the DNS records to use in
binding the DID to the DNS domain. This technique could also be used with
`did:webvh` (and `did:web` for that matter) if the DID is published on a platform
(such as GitHub) and the controller wants to bind it to its DNS domain.

## Future Possibilities

In the future, as `did:webvh` becomes more accepted, we would like to see
`did:webvh` explicitly added to the [High Assurance DIDs with DNS] specification
beside `did:web`.

Since `did:webvh` and the [High Assurance DIDs with DNS] specification both have
the goal of adding methods for additional verifications of the DID, the support
for `did:webvh` in the [High Assurance DIDs with DNS] could be more specific to
the DID Method. For example, the key in the DNS record could be a required
`did:webvh` witness, with its Data Integrity proof being a part of the
DID log entry rather than in the DIDDoc itself.
