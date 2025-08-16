# How is DID Duplicity Handled in did:webvh?

## DID Duplicity

DID duplicity occurs when two or more divergent DID Logs exist that share a common ancestor entry but differ in subsequent entries, so that resolvers obtain different states for the same `versionNumber` of a DID. Recall that in `did:webvh`, the `versionId` value consists of an incrementing `versionNumber`, plus a hash that links the version to all previous versions of the DID, and to its SCID. So while the `versionId` would differ in the two (or more) updates, the `versionNumber` would be the same and available for detection. In `did:webvh`, the most serious form of duplicity is a **split-view attack** — where a DID Controller or hosting environment selectively serves different valid branches of the DID Log to different resolvers, causing them to see inconsistent states.

## Example Scenario

The DID Controller creates (maliciously or accidentally) two or more valid but differing updates to a DID starting from the same current tip of the DID Log, and publishes them both in sequence or serves them to different resolvers.

## Mitigations in did:webvh

The specification and common deployment practices include multiple measures that prevent or detect conflicting parallel updates:

- **Independent `did:webvh` server:**
  - Servers that verify DID Logs before publication will reject an update that does not extend the current published tip. Independent hosting is the common model.
- **Witnesses:**
  - Witnesses **MUST NOT** sign more than one child entry from the same parent. Conflicting updates are rejected.
- **Witness proof consolidation:**
  - The component assembling `witness.json` will fail to produce an update file if proofs correspond to conflicting branches.
- **Watchers:**
  - Watchers reject invalid versions they receive and can raise alerts about divergence.
- **Resolvers with state tracking:**
  - Resolvers that remember the highest `versionId`/entry hash seen will detect a branch that does not extend the latest known tip.
- **Cross-source resolution:**
  - Resolvers can compare results from multiple sources (e.g., mirrors, Watchers, CDNs) to detect split-view behavior.

If none of these independent components are present, the second update could overwrite the first without detection, resulting in resolvers seeing different entries before and after the second update. True duplicity — the split-view case — arises only if the DID Controller or hosting platform serves different branches to different clients.

## The Role of Governance

While the `did:webvh` specification deliberately leaves governance out of scope, governance is an important aspect of any real-world deployment. Even a minimal governance model — or simply the use of one or more independent components as described above — is likely to prevent duplicity by blocking conflicting updates before they are published.

For more detail, see the [Security Considerations](https://identity.foundation/didwebvh/v1.0/#security-considerations) section of the specification, and specifically the “Conflicting parallel updates / split view” threat.
