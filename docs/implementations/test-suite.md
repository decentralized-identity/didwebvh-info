# The `did:webvh` Test Suite

The [`did:webvh` Test Suite][test-suite-repo] is an interoperability and conformance test suite
for [`did:webvh` v1.0](https://identity.foundation/didwebvh/v1.0/). It checks
that `did:webvh` [implementations](README.md) produce DID logs that other
implementations can resolve, that they resolve each other's logs to the same
results, and that they reject logs that are invalid.

## How It Works

The test suite has no single "reference" implementation. Every implementation
is tested against every other one, and the specification and the [DIF
`did:webvh` Work Item][work-item] decide which behaviour is correct.

1. **Scenarios.** Each test scenario is a small, language-agnostic YAML script
   (`vectors/<scenario>/script.yaml`) that describes the steps to run: create
   a DID, update it, rotate keys, add witnesses, deactivate it, and resolve it.
   Keys are derived from fixed seeds, so running a script again gives the same
   output.
2. **Generation.** Each implementation runs the scripts with its own library,
   and commits the DID logs (`did.jsonl`, and `did-witness.json` where needed)
   and resolution results it produces under `vectors/<scenario>/<impl>/`.
3. **Cross-resolution.** Each implementation then resolves the logs that
   *every* implementation committed, including its own, and compares its
   output with the committed results.
4. **Results.** Each implementation's results are written to
   `implementations/<impl>/status.md`, with the details of any differences in
   `diffs.txt`.

An implementation resolving its own logs should always match exactly. A
difference when resolving another implementation's logs means the two
resolvers genuinely disagree. Results are compared after [JCS] canonicalisation,
so key ordering and whitespace don't count, but nothing else is normalised.
Each difference is either a bug in an implementation or a question for the
Working Group about what the specification means.

Each implementation is built and run in its own Docker container, so the only
thing you need to run the test suite is Docker. It can also be run against a
branch or a fork of an implementation's library, so a fix can be checked before
it is merged.

## What Is Tested

**Valid DIDs.** Scenarios that each implementation creates and that every
implementation resolves:

| Scenario | What it covers |
|---|---|
| `basic-create` | Create a DID and resolve it |
| `basic-update` | Create, then update once |
| `multi-update` | Create, then update twice; resolve each version |
| `key-rotation` | Rotate the update key |
| `multiple-update-keys` | Two update keys; an update signed by the second |
| `pre-rotation` | Create with a pre-rotation commitment (`nextKeyHashes`) |
| `pre-rotation-consume` | Update signed by a pre-rotated key |
| `witness-threshold` | Witnessed DID, with witness proofs |
| `witness-update` | Change the witness configuration from 2-of-2 to 1-of-1 |
| `portable` | Create a portable DID |
| `portable-move` | Move a portable DID to a new domain |
| `services` | Add services |
| `deactivate` | Deactivate a DID |

**Invalid DIDs.** The `negative-*` scenarios are DID logs and DIDs that a
conforming resolver must reject, each with the error it is expected to return.
Each one comes from a real security bug found in an audit of several
implementations, covering things such as witness proofs replayed from another
DID, duplicate witnesses, a witness threshold of zero, SCID mismatches, path
traversal and percent-encoding tricks in the DID, a non-increasing or future
`versionTime`, and an unknown method version. See the [negative test vectors]
for the full list.

## Implementations and Results

The following implementations are in the test suite. Follow the links for each
implementation's latest results.

| Implementation | Library | Results |
|---|---|---|
| TypeScript | [didwebvh-ts](https://github.com/decentralized-identity/didwebvh-ts) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/ts/status.md) |
| Python | [didwebvh-py](https://github.com/decentralized-identity/didwebvh-py) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/python/status.md) |
| Rust | [didwebvh-rs](https://github.com/decentralized-identity/didwebvh-rs) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/rust/status.md) |
| Java (DIF) | [didwebvh-java](https://github.com/decentralized-identity/didwebvh-java) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/java/status.md) |
| Java (EECC) | [european-epc-competence-center/didwebvh](https://github.com/european-epc-competence-center/didwebvh) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/java-eecc/status.md) |
| Dart | [didwebvh-dart](https://github.com/decentralized-identity/didwebvh-dart) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/dart/status.md) |
| ThisDID (resolver only) | [thisdid](https://github.com/decentralized-identity/thisdid) | [status](https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/implementations/thisdid/status.md) |

ThisDID is a universal resolver, so it only resolves the other
implementations' logs and doesn't generate its own.

Each `status.md` has three sections: **DID Creation** (did the implementation
generate its own logs for each scenario?), **Negative Resolution** (did it
reject each invalid log?), and **Cross-Resolution** (did it resolve every
implementation's logs to the expected result?). Results are marked:

- ✅ **PASS**: an exact match.
- 🔶 **DIFF**: the DID resolved, but the result differs from the committed one.
- ❌ **FAIL**: resolution failed, or an invalid log was accepted.
- ⚠️ **SKIP**: the implementation doesn't support that scenario.

## Adding Your Implementation

If you have a `did:webvh` implementation, please add it to the test suite.
You'll need a Docker build for your library and a small harness that reads the
scenario scripts, writes your implementation's logs and resolution results,
and resolves the other implementations' logs. The existing implementations in
the repository's `implementations/` folder are the best starting point. See the
[`did:webvh` Test Suite][test-suite-repo] repository for the details, and raise an issue or
pull request there.

[test-suite-repo]: https://github.com/decentralized-identity/didwebvh-test-suite
[work-item]: https://identity.foundation/working-groups/identifiers-discovery.html
[JCS]: https://www.rfc-editor.org/rfc/rfc8785
[negative test vectors]: https://github.com/decentralized-identity/didwebvh-test-suite/blob/main/vectors/NEGATIVE_VECTORS.md
