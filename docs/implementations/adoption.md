# `did:webvh` Adoption

The following is a list of known adoptions of `did:webvh`, including
deployments of `did:webvh` software and inclusions of `did:webvh` in
standards, reference architectures, and governance frameworks. If you have
an adoption that is not listed here, please let us know (or submit a PR).
It is really helpful to the community to know about the growing ecosystem
around `did:webvh`.

## United Nations Transparency Protocol (UNTP)

The [UN Transparency Protocol], which addresses supply chain verifiability and
anti-greenwashing, has included `did:webvh` as an acknowledged DID method in
its work-in-progress specification. It is listed as Recommended (Advanced) for
institutional and organizational identifiers requiring verifiable history, key
rotation, and auditability — particularly for Digital Identity Anchors,
credential issuers, and registry maintainers.

## Linux Foundation Decentralized Trust (Proof of Personhood)

[LF Decentralized Trust] is using `did:webvh` as part of its Decentralized
Trust Graph initiative, which aims to provide Proof of Personhood for the Linux
kernel project and other open source projects. The effort is a response to
supply chain attacks such as the XZ Utils backdoor, and is centered on a
verifiable trust graph model using DIDs and verifiable relationship credentials.
Reference implementations were contributed to LFDT Labs at the 2026 LF Member
Summit.

## Government of Canada

The [Digital Governance Standards Institute (DGSI)], an independent division
of Canada's Digital Governance Council, published a revised edition of
[DGSI/TS 115], Technical Specification for Digital Credentials and Digital
Trust Services, in March 2026. `did:webvh` (listed as DIF DID:webvh) is
explicitly included in section 8.1.2 alongside W3C DID:web, DID:key, and
X.509 Certificates as a required supported identifier method for conformant
implementations.

## Swiss Confederation (swiyu e-ID)

The Swiss Federal Council has selected `did:webvh` as the DID method for the
[swiyu Trust Infrastructure], Switzerland's national e-ID system. The swiyu
public beta launched in early 2025, with full production deployment planned
for late 2026. `did:webvh` is used to represent issuers and verifiers in the
trust infrastructure, with DID documents and DID logs hosted on the swiyu Base
Registry.

## Government of British Columbia, Canada

The [Government of British Columbia Digital Trust] team has deployed
`did:webvh` infrastructure in support of BC Gov's digital identity initiatives.
This includes a production-grade, multi-tenant `did:webvh` server built in
Python and deployed to a container orchestration environment, used to support
the issuance of Verifiable Credentials including privacy-preserving [AnonCreds]
credentials. `did:webvh` support is also integrated into [Traction], BC Gov's
managed deployment of [ACA-Py], and into the [BC Wallet], the mobile wallet
application for British Columbia residents.

## Affinidi

[Affinidi] has developed open source implementations of `did:webvh` for their
clients, including the Rust implementation [didwebvh-rs] hosted at DIF.
Affinidi has also contributed the OpenVTC reference implementation to LFDT
Labs, which uses `did:webvh` as its identity foundation.

## Procivis

[Procivis] has developed open source implementations of `did:webvh` for their
clients.

[Government of British Columbia Digital Trust]: https://www2.gov.bc.ca/gov/content/governments/government-id
[AnonCreds]: https://www.lfdecentralizedtrust.org/projects/anoncreds
[Traction]: https://digital.gov.bc.ca/digital-trust/technical-resources/traction/
[ACA-Py]: https://aca-py.org
[BC Wallet]: https://www2.gov.bc.ca/gov/content/governments/government-id/bc-wallet
[Digital Governance Standards Institute (DGSI)]: https://dgc-cgn.org/standards/
[DGSI/TS 115]: https://dgc-cgn.org/product/dgsi-ts-115/
[swiyu Trust Infrastructure]: https://swiyu-admin-ch.github.io/technology-stack/
[UN Transparency Protocol]: https://untp.unece.org/docs/specification/VerifiableCredentials#did-methods
[LF Decentralized Trust]: https://www.lfdecentralizedtrust.org/blog/decentralized-trust-infrastructure-at-lf-a-progress-report
[Affinidi]: https://affinidi.com
[didwebvh-rs]: https://github.com/decentralized-identity/didwebvh-rs
[Procivis]: https://procivis.ch
