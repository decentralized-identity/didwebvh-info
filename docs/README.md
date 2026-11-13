
# DIDs with Verifiable History

This site covers two related DID methods, both developed at the [Decentralized
Identity Foundation (DIF)](https://identity.foundation):

- **`did:webvh`** (`did:web` + Verifiable History): a web-located DID that is
  compatible with `did:web`. v1.0 is the current, stable version.
- **`did:vh`** (DID + Verifiable History): the same verifiable history, with no
  location in the DID. It is a v0.1 Editors Draft.

Both DIDs are built on the same self-certifying identifier (SCID), so the
difference is easy to see:

```text
did:webvh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:example.com:dids:issuer
did:vh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ
```

Most of this site is about `did:webvh`. Much of it applies to `did:vh` too,
because the two methods share the DID Log format, the SCID, key authorization,
pre-rotation, witnesses and watchers.

## `did:webvh`

The `did:webvh` DID Method (`did:web` + Verifiable History) was developed with the aim of enabling greater trust and security 
than `did:web` without compromising the simplicity of `did:web`.
Core features of the `did:webvh` method that complement `did:web` include:

- **DID-to-HTTPS transformation** that is the same as `did:web`.
- **A Verifiable History**: The ability to resolve the full history of the DID using a verifiable chain of
  updates to the DIDDoc from genesis to deactivation.
- **A Self-Certifying Identifier (SCID)**: The SCID, globally unique and
  embedded in the DID, is derived from the initial DID log entry. It ensures the integrity
  of the DID's history mitigating the risk of attackers creating a new object with
  the same identifier.
- **Authorized Keys**: DIDDoc updates contain a proof signed by the DID Controllers *authorized* to
  update the DID.
- **Pre-rotation Keys** (optional): The mechanism for publishing pre-rotation keys prevents the loss of
  control of a DID in cases where an active private key is compromised.
- **Witnesses** (optional): The mechanism for having witnesses enables the collaborative
  approval of updates to the DID by a DID Controller before publication.
- **DID Portability** (optional): The mechanism for enabling portability allows
  the DID's web location to be moved and the DID string to be updated, both while retaining
  a connection to the predecessor DID(s) and preserving the DID's verifiable history.

In addition, the `did:webvh` method supports:

- **A DID URL path handling** that defaults (but can be overridden) to automatically
  resolving `<did>/path/to/file` by using a comparable DID-to-HTTPS translation
  as for the DIDDoc.
- **A DID URL path `<did>/whois`** that defaults to automatically returning (if
  published by the [[ref: DID controller]]) a [[ref: Verifiable Presentation]]
  containing [[ref: Verifiable Credentials]] with the DID as the
  `credentialSubject`, signed by the DID. It draws inspiration from the
  traditional WHOIS protocol [[spec:rfc3912]], offering an easy-to-use,
  decentralized, trust registry.
- **[High Assurance DIDs with DNS] mechanism** that is the same as used for `did:web`.

[High Assurance DIDs with DNS]: https://datatracker.ietf.org/doc/draft-carter-high-assurance-dids-with-dns/

The `did:webvh` specification and based on it, the implementer's guide, were developed in parallel with the development of two
proof of concept implementations. The specification/implementation interplay
helped immensely in defining a practical, intuitive, straightforward, DID
method. The existing implementations of the `did:webvh` DID
Method are listed in the [Implementers Guide](./implementers-guide/README.md). The current
implementations range from around 1500 to 2000 lines of code.

An example of a `did:webvh` evolving through a series of versions can be seen in
the [did:webvh Examples](./example.md) included on this site.

## `did:vh`

!!! warning "Editors Draft"
    The [`did:vh` specification](https://identity.foundation/didvh/next/) is a
    v0.1 Editors Draft. It can change at any time.

`did:vh` is the location-independent sibling of `did:webvh`. A `did:vh` DID is
just `did:vh:<SCID>`. It has no domain name or path, so it isn't tied to any
place where its DID Log is published. Otherwise, `did:vh` stays as close to
`did:webvh` as it can: the same DID Log (`did.jsonl`), SCID, signed updates,
pre-rotation, witnesses and watchers.

Because the DID doesn't say where its log is, finding the log is separate from
resolving the DID. The client sources the DID Log first: it might arrive with
the DID, come from a watcher, be exchanged peer-to-peer, or be found at a web
location. The client then gives the log to the resolver, either directly or by
reference, and the resolver verifies it. The SCID proves that the log is the
DID's history, wherever it came from.

Removing the location gives `did:vh` some properties a web-located DID can't
have:

- **Permanence.** The DID never changes when the log moves, so there is no need
  for a portability mechanism.
- **Location independence.** The log can be kept on a web server, with a
  watcher, in a database, on a ledger, or only in the wallets of the parties to
  a relationship, and in several of these at once.
- **Peer-to-peer use.** Two parties can exchange their DID Logs directly, as
  with `did:peer`, while keeping key rotation, pre-rotation and the other
  verifiable history features.

Read more in the [Introduction to did:vh](./didvh.md).

## Which One Should I Use?

| Use `did:webvh` when... | Use `did:vh` when... |
|---|---|
| The DID should be tied to a domain and that domain's reputation. | The identifier must never change, even if where its log is kept changes. |
| Anyone should be able to resolve the DID from the DID alone. | There is no web host, or the log is kept by an ecosystem, a watcher, or the parties themselves. |
| You want to publish a parallel `did:web`, or use `/whois` and DID URL paths. | The parties exchange DID Logs directly, peer-to-peer. |
| You need a stable, v1.0 specification today. | You can work with a draft specification. |

See also the FAQ: [did:vh or did:webvh -- which should I use?](./faq/didvh-or-didwebvh.md)
