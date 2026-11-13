# Introduction to `did:vh`

!!! warning "Editors Draft"
    The [`did:vh` specification](https://identity.foundation/didvh/next/) is a
    v0.1 Editors Draft. It can change at any time. The specification is the
    authority: if this page disagrees with it, the specification is right.

`did:vh` (DID + Verifiable History) is a DID method that gives a DID a
cryptographically verifiable history without tying it to any location. It is
derived from `did:webvh`, and is the same method with the "web" taken out:

```text
did:webvh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ:example.com:dids:issuer
did:vh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ
```

## Why a DID Without a Location?

In `did:webvh`, the domain name does two jobs: it tells a resolver where to find
the DID Log, and it makes the DID a web identifier. It isn't needed for
security, because the SCID and the verifiable history provide that on their
own. But it does tie the DID to one location. When the location changes, the
DID changes. `did:webvh` handles this with its optional portability mechanism,
but the DID is still no longer the same string.

Many uses of DIDs need an identifier that never changes: a permanent account
identifier, a DID embedded in content-addressed data, or one held in long-lived
credentials. Others have no web location at all: DIDs exchanged between two
parties, DIDs kept in an organisation's database, or DIDs anchored on a ledger.
`did:vh` is for those uses.

## What Is the Same as `did:webvh`

`did:vh` is deliberately as close to `did:webvh` as its lack of a location
allows. These are the same in both methods:

- The DID Log format: a [JSON Lines](https://jsonlines.org/) file (`did.jsonl`)
  of entries with `versionId`, `versionTime`, `parameters`, `state` and
  `proof`.
- The SCID and entry hash algorithms, chaining every entry to the one before.
- Key authorization and [pre-rotation](./implementers-guide/prerotation-keys.md).
- [Witnesses](./implementers-guide/witnesses.md) (identified by `did:key` DIDs)
  and the witness proofs file (`did-witness.json`).
- Watchers.
- The `versionId`, `versionTime` and `versionNumber` resolution options.

The [relationship section of the
specification](https://identity.foundation/didvh/next/#relationship-to-didwebvh)
summarises the differences. An implementation of `did:webvh` can support
`did:vh` by replacing the DID-to-HTTPS transformation with the `did:vh`
resolution options, and dropping the features that depend on a web location.

## What Is Different

| | `did:webvh` | `did:vh` |
|---|---|---|
| DID | `did:webvh:<SCID>:<domain>[:<path>]` | `did:vh:<SCID>` |
| Finding the DID Log | The DID-to-HTTPS transformation | The client sources the log and gives it to the resolver |
| `method` parameter values | `did:webvh:1.0` | `did:vh:1.0` |
| Portability (`portable` parameter) | Optional | Not used: the DID never changes |
| Parallel `did:web` DID | Optional | Not applicable |
| DID URL paths, `/whois`, implicit `#files` and `#whois` services | Defined | Not defined |

## Resolving a `did:vh` DID

A `did:vh` resolver doesn't look for the DID Log. It implements the standard
DID Resolution `resolve(did, resolutionOptions)` function, and the client gives
it the DID Log and the witness proofs file (if any) in the [`did:vh` resolution
options](https://identity.foundation/didvh/next/#didvh-resolution-options),
in one of two ways:

- **Pass directly**: the content of the files, in the `didLog` and `didWitness`
  options.
- **Pass by reference**: a reference to each file, in the [`srcLog` and
  `srcWitness`
  options](https://identity.foundation/didvh/next/#the-srclog-and-srcwitness-options).
  A reference can be a web location (`https`), a URL with another scheme the
  resolver supports (such as `ipns`), or, for a resolver local to its client
  only, a `file:` URL or loopback `http` web location.

For example, passing the files by reference to a web location:

```json
{
  "did": "did:vh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ",
  "resolutionOptions": {
    "srcLog": "https://example.com/dids/issuer/did.jsonl",
    "srcWitness": "https://example.com/dids/issuer/did-witness.json"
  }
}
```

The resolver verifies every entry of the log exactly as a `did:webvh` resolver
does, and returns the DIDDoc. A reference is not authoritative: it says
nothing about who controls the DID, and the log found there may not be the
latest.

A DID URL can also carry a web location, in the [`src` DID URL
parameter](https://identity.foundation/didvh/next/#the-src-did-url-parameter),
adopted from the proposed `did:scid` metamethod:

```text
did:vh:QmfGEUAcMpzo25kF2Rhn8L5FAXysfGnkzjwdKoNPi615XQ?src=https://example.com/dids/issuer
```

The `src` value names the location holding `did.jsonl` and `did-witness.json`.
Because a DID URL can come from an untrusted party, `src` must not be a `file:`
or `http` URL.

## Sourcing the DID Log

Before resolving, the client needs to source the DID Log: get the log itself,
or a reference to where it is kept. The specification describes the common
ways [non-normatively](https://identity.foundation/didvh/next/#sourcing-the-did-log),
and a log sourced in any of them is verified in the same way:

- **[Known in
  context](https://identity.foundation/didvh/next/#known-in-context).** The log,
  or its location, arrives with the DID (for example, in a credential
  exchange), is held by an ecosystem's DID host, was kept from an earlier
  resolution, or is named in a `src` DID URL parameter.
- **[From watchers](https://identity.foundation/didvh/next/#from-watchers).** A
  watcher indexes DID Logs by SCID, and a `did:vh` DID *is* its SCID, so a
  client can ask a watcher for the log with `GET <WATCHER URL>/log?scid=<SCID>`.
- **[Peer-to-peer
  exchange](https://identity.foundation/didvh/next/#peer-to-peer-exchange).**
  Parties exchange DID Logs directly, in the manner of `did:peer`, and send
  each other updates. Unlike `did:peer`, the DIDs keep key rotation and
  pre-rotation. A new `did:vh` DID can be created for each relationship.
- **[From a web
  location](https://identity.foundation/didvh/next/#from-a-web-location).** A
  location learned from a `src` parameter, from the DIDDoc's `alsoKnownAs`
  property, or from context.

## Freshness and Duplicity

With no authoritative location, a client faces two risks that `did:webvh`
handles by trusting the DID's web location:

- **Staleness**: the copy of the log it has may be missing recent updates, such
  as a key rotation or deactivation.
- **Duplicity**: the DID Controller, or an attacker holding its keys, could
  fork the log and show different versions to different parties.

A client reduces these risks by sourcing the log from a source expected to be
current, such as a watcher listed in the log, and by comparing copies. A
resolver can do the comparison itself, using the `checkWatchers`,
`extraWatchers` and `minCopies` resolution options, and fails with `logForked`
if the log has been forked. Witnesses and watchers matter more for `did:vh`
than for `did:webvh`. DID Controllers of widely relied-on `did:vh` DIDs are
encouraged to use them, and relying parties are encouraged to use watchers they
trust. See [Log Freshness and
Duplicity](https://identity.foundation/didvh/next/#log-freshness-and-duplicity)
in the specification.

## Relationship to `did:scid`

The proposed
[`did:scid`](https://lf-toip.atlassian.net/wiki/spaces/HOME/pages/88572360/DID+SCID+Method+Specification)
metamethod defines a family of location-independent DIDs, each using the format
of an existing SCID-based DID method. Its `did:scid:vh` format uses the
`did:webvh` format, so it is comparable to `did:vh`. `did:vh` shares its design
goals and adopts its `src` parameter, but is a standalone DID method, and
carries the specification version in the `method` parameter of the log rather
than in the DID. See [Relationship to
`did:scid`](https://identity.foundation/didvh/next/#relationship-to-didscid) in
the specification.

## Learn More

- [The `did:vh` specification](https://identity.foundation/didvh/next/)
- [The specification source on GitHub](https://github.com/decentralized-identity/didvh),
  for issues and discussion
