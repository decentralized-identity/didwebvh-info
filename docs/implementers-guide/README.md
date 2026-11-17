# The `did:webvh` Implementer's Guide

This series of articles shares insights from developers and deployers of Trust
DID Web (`did:webvh`), highlighting lessons learned from real-world deployments
and use cases. 

The guide explores the features of `did:webvh`, how to deploy them,
what’s covered in the specification versus what implementers need to handle,
provides pointers to existing implementations, and more.

!!! note "Using this guide for `did:vh`"
    Most of this guide also applies to [`did:vh`](../didvh.md), which shares
    `did:webvh`'s DID Log, SCID, [valid keys](./did-valid-keys.md),
    [pre-rotation](./prerotation-keys.md) and [witnesses](./witnesses.md). The
    exceptions are the DID-to-HTTPS steps of the [resolver
    algorithm](./resolver-algorithm.md), which `did:vh` replaces with its
    [resolution
    options](https://identity.foundation/didvh/next/#didvh-resolution-options),
    and [DID portability](./did-portability.md), which `did:vh` doesn't need.

Contributions to the guide are welcome! If you have learned something about
deploying did:webvh and want to share -- open an [issue], or submit a pull request
to add an article. If you do add an article, make sure you put a link to your
new article in the `mkdocs.yml` file in the root of the [didwebvh-info]
repository (or we are happy to do it for you...).

[issue]: https://github.com/decentralized-identity/didwebvh-info
[didwebvh-info]: https://github.com/decentralized-identity/didwebvh-info
