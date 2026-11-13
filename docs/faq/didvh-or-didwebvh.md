# `did:vh` or `did:webvh`: Which Should I Use?

`did:webvh` and `did:vh` share the same verifiable history: the DID Log, the
SCID, signed updates, pre-rotation, witnesses and watchers. The difference is
whether the DID contains a web location.

```text
did:webvh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:example.com:dids:issuer
did:vh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ
```

## Choose `did:webvh` When

- **The DID should be tied to a domain.** A `did:webvh` DID carries a domain
  name, so it can draw on that domain's reputation, and can be secured further
  with [High Assurance DIDs with
  DNS](../implementers-guide/high-assurance-dids-with-dns.md).
- **Anyone should be able to resolve the DID from the DID alone.** A resolver
  turns a `did:webvh` DID into an HTTPS URL and retrieves the log. The web
  location is also the reference copy of the log, which simplifies checking
  that the log is current.
- **You want web features.** `did:webvh` can be published as a parallel
  `did:web` DID, and defines DID URL path handling, `/whois`, and the implicit
  `#files` and `#whois` services.
- **You need a stable specification.** `did:webvh` v1.0 is published and
  implemented by several [implementations](../implementations/README.md).

## Choose `did:vh` When

- **The identifier must never change.** A `did:vh` DID is just its SCID, so it
  stays the same wherever its log is kept.
- **There is no web host**, or the log is better kept somewhere else: with a
  watcher, in an ecosystem's registry, on a ledger, or in several of these.
- **The parties exchange DIDs directly.** `did:vh` DIDs can be used
  peer-to-peer, like `did:peer`, with key rotation and pre-rotation. A new
  `did:vh` DID can be created for each relationship.
- **You can work with a draft.** The [`did:vh`
  specification](https://identity.foundation/didvh/next/) is a v0.1 Editors
  Draft.

## Why Not Just Use `did:webvh` Portability?

`did:webvh` portability lets a DID move to a new web location while keeping its
SCID and history. But the DID string changes when it moves, and anyone holding
the old DID has to follow the history to the new one. A `did:vh` DID never
changes, because it never had a location to change.

## What Does `did:vh` Give Up?

Without a location in the DID, a resolver can't find the log on its own. The
client has to source it first, from context, a watcher, a peer, or a web
location. There is also no authoritative copy of the log, so a client that
needs the current version should source it from a source expected to be
current, and compare copies to detect a forked log. Witnesses and watchers
matter more for `did:vh` than for `did:webvh` for this reason. See the
[Introduction to did:vh](../didvh.md) and the specification's [Log Freshness and
Duplicity](https://identity.foundation/didvh/next/#log-freshness-and-duplicity)
section.
