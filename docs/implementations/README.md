# did:webvh Implementations

Implementations of `did:webvh` software for DID Controller registrars,
resolvers, controllers and/or servers can be found here. See each
implementation's repository for details on features and capabilities. Please
let us know (or submit a PR) if you have an implementation that is not listed
here, or if you want to update how your implementation is described.

The [`did:webvh` Implementations website] and repository is used for
interoperability and conformance testing to ensure that each implementation is
compliant with the specification and can interoperate with other
implementations. The goal is to ensure that the `did:webvh` method is
implemented consistently across a wide range of programming languages and
platforms. As implementations mature, they can be added to the repository and
website.

## Full Implementations

The following are complete implementations of `did:webvh` that support the
full set of features and capabilities defined in the current specification.
They have been tested for interoperability, and the developers have been
comparing notes and providing feedback to one another and to the Working Group
to clarify the specification and help future implementors.

- [DIF] -- [Typescript](https://github.com/decentralized-identity/didwebvh-ts)
- [DIF] -- [Python](https://github.com/decentralized-identity/didwebvh-py)
- [Affinidi] at [DIF] -- [Rust](https://github.com/decentralized-identity/didwebvh-rs),
  [Crate](https://crates.io/crates/did-webvh) -- Production-ready implementation
  informed by security reviews, audits, and production deployment experience.
  Notable features include external signer support (the library never handles
  secret key material directly), enabling clean integration with Key Management
  Services (KMS) and Hardware Security Modules (HSMs) to meet regulated
  environment requirements. Also includes developer convenience functions for
  witness operations, improved error messages, and an optional HTTP client
  (gated behind a feature flag).

## Partial/PoC Implementations

These implementations are known, but are either incomplete or not fully
compliant with the latest specification. They may be useful for building out
new implementations.

- [Nuts Foundation] -- [Go](https://github.com/nuts-foundation/trustdidweb-go)
  (Registrar/Resolver)
- [DIF] -- [Rust-v0.5](https://github.com/decentralized-identity/didwebvh-rs-v0.5)
  (Experimental Registrar/Resolver)

## Other Implementations

These are implementations we know about, but not much. We'll try to learn more
and categorize them better in the future.

- [Procivis] -- [Rust](https://github.com/procivis/one-core/tree/main/lib/one-core/src/provider/did_method/webvh)
  (Resolver)

## Deployment Tools

These are tools that can be used to deploy and manage `did:webvh`
implementations, such as servers, watchers and resolvers.

- [DIF] -- [`did:webvh` Server - Python](https://github.com/decentralized-identity/didwebvh-server-py)
  (Server)
- [DIF] -- [`did:webvh` Watcher - Python](https://github.com/decentralized-identity/didwebvh-watcher-py)
  (Watcher)
- [DIF] -- [`did:webvh` Universal Resolver Driver](https://github.com/decentralized-identity/uni-resolver-driver-did-webvh)
  -- based on the [Typescript](https://github.com/decentralized-identity/didwebvh-ts)
  implementation.

Note that the DIF [Rust](https://github.com/decentralized-identity/didwebvh-rs)
implementation includes all of the same components (Registrar, Resolver,
Witness, Watcher) in a single repository that can be used to build out custom
deployment tools.

## DID Controller Capabilities

The following are digital trust agent frameworks that support the `did:webvh`
method, allowing users to create, issue, hold, request, present and verify
verifiable credentials rooted with `did:webvh` DIDs. [ACA-Py] is primarily a
server-side framework, while [Credo-TS] is both a server-side and mobile wallet
framework.

- [OWF] -- [ACA-Py Plugin] -- Full `did:webvh` support including registrar,
  resolver, witness, and watcher capabilities. Enables multi-tenant deployments
  to create and manage `did:webvh` DIDs with witness-based attestation. In
  production use in deployments including BC Gov's Traction platform.
- [OWF] -- [Credo-TS Module] -- `did:webvh` resolver support, with registrar
  support in active development. As both a server-side and mobile wallet
  framework, brings `did:webvh` into a broad range of wallet and agent
  deployment contexts.
- [OWF] -- [Bifold Wallet] -- A React Native (iOS and Android) mobile wallet
  built on top of [Credo-TS], inheriting its `did:webvh` support. [BC Wallet],
  the mobile wallet for British Columbia residents, is built on top of Bifold.

[Bifold Wallet]: https://github.com/openwallet-foundation/bifold-wallet
[BC Wallet]: https://www2.gov.bc.ca/gov/content/governments/government-id/bc-wallet
[`did:webvh` Implementations website]: https://identity.foundation/didwebvh-implementations/
[ACA-Py Plugin]: https://github.com/openwallet-foundation/acapy-plugins/tree/main/webvh
[Credo-TS Module]: https://github.com/openwallet-foundation/credo-ts/pull/2238

[DIF]: https://identity.foundation
[Nuts Foundation]: https://nuts.foundation
[Procivis]: https://procivis.ch
[Affinidi]: https://affinidi.com
[OWF]: https://openwallet.foundation
[ACA-Py]: https://aca-py.org
[Credo-TS]: https://credo.js.org/
