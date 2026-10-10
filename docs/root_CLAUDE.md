# CLAUDE.md — didwebvh-info (the didwebvh.info site)

## About This Repository

The source of the `did:webvh` information site, <https://didwebvh.info>, published from
<https://github.com/decentralized-identity/didwebvh-info>. The local clone's `origin` is the
fork `swcurran/didwebvh-info`. See [README.md](README.md) for contributing (DCO sign-off on
every commit). The site is informative: the specifications are the authority, and site text
must not contradict them.

**Current build (to be replaced):** MkDocs Material with `mike` versioning. Markdown is in
`./`; navigation is in `mkdocs.yml`; `scripts/prepmkdocs.sh` copies root `*.md` files into
`./root_*.md` for the Contributing pages; `.github/workflows/publish-docs.yml` deploys
`main` as `latest` and `docs-v*` branches as versioned docs.

## Notes for Claude

- **Don't commit.** Edit files only; the user reviews and commits.
- **Wording:** say "pass directly" / "pass by reference" for giving a log to a resolver (not
  "conveyance"); use "web location" only for `https` (or loopback `http`) `src` references.
- **Links to specs:** link to sections by absolute anchor URL. Spec-Up derives anchors from
  heading text, so check a link against the rendered spec before using it.

## The Specification Family

The site is to introduce these alongside `did:webvh`. Read the specs themselves, not these
summaries, before writing about them.

| Spec | Published | Source / local clone | Status |
|---|---|---|---|
| `did:webvh` v1.0 | <https://identity.foundation/didwebvh/v1.0/> | `decentralized-identity/didwebvh`, `/d2/repos/didwebvh` (`spec-v1.0/`) | Current, stable |
| `did:webvh` Editors Draft | <https://identity.foundation/didwebvh/next/> | same repo, `spec/` | Work towards the next version |
| `did:webvh` Experimental (on VH-Log) | `https://identity.foundation/didwebvh/experimental/` (once merged) | same repo, `spec-exp/`, branch `exp-wvh-on-vhlog` | Experimental, not for implementation |
| VH-Log | <https://swcurran.github.io/VH-Log/> | `swcurran/VH-Log`, `/d2/repos/VH-Log` | Pre-draft Editors Draft v0.1 |
| `did:vh` | <https://swcurran.github.io/didvh/> | `swcurran/didvh`, `/d2/repos/didvh` | Pre-draft Editors Draft v0.1 |

Each of those repos has its own CLAUDE.md with design decisions and TODOs. Read the relevant
one when writing about that spec.

### VH-Log (Verifiable History Log)

- The log mechanism of `did:webvh` v1.0, extracted and generalised (split out 2026). An
  append-only, hash-chained JSON Lines log of versions of an arbitrary JSON `state` object, with
  a SCID derived from the first entry, signed entries, `parameters`, key pre-rotation,
  witnesses, watchers, a resolution algorithm, version selection, and transport (HTTPS/SSRF/CORS)
  rules.
- A **specialisation** defines the `state` type, the log identifier and location, resource
  names, and extra parameters. Default file names are `vh-log.jsonl` / `vh-log-witness.json`.
- Version parameter `logVersion` (`vh-log:1.0`); a specialisation may designate its own
  (`did:webvh` and `did:vh` use `method`).
- Newer than `did:webvh` v1.0: resolver-side **comparing copies of a log** (fork, truncation and
  rollback detection), with the `checkWatchers`, `extraWatchers` and `minCopies` resolution
  options, and `copies` / `warnings` in the result.
- Planned (agreed, not yet in the spec): mandatory key pre-rotation (`updateKeys` removed,
  `nextKeyHashes` → `prerotationHashes`), and an `eddsa-jcs-prerotation-2026` cryptosuite.
  Don't describe these as current.
- Its security/privacy sections are non-normative; the requirements are in the normative body.

### did:vh

- The first VH-Log specialisation: `state` is a DIDDoc, and the DID is just `did:vh:<SCID>`, with
  **no location**. It is the location-independent sibling of `did:webvh`, kept as close to it as
  possible (same `did.jsonl` / `did-witness.json`, `did:key` witnesses, `method` = `did:vh:1.0`).
- Resolution is DID Resolution's `resolve(did, resolutionOptions)`. The client passes the log
  directly (`didLog` + `didWitness`) or by reference (`src`: an `https` web location, another
  URL scheme such as `ipns`, or, for a local resolver only, a `file:` directory or loopback
  `http`). The resolver does not discover logs.
- Sourcing the log is non-normative: known in context, from watchers (`GET /log?scid=`),
  peer-to-peer exchange (in the manner of `did:peer`, but with rotation and pre-rotation), or a
  web location. Covers freshness and duplicity, since there is no authoritative location.
- No `portable` parameter, no implicit `#files` / `#whois` services, no parallel `did:web`.
- Comparable to the `did:scid:vh` format of the proposed ToIP `did:scid` metamethod, and adopts
  its `src` parameter.

### Experimental did:webvh on VH-Log

- `did:webvh` redefined as a VH-Log specialisation, to test whether that can be done without
  changing existing DIDs (`method` stays `did:webvh:1.0`, implying `vh-log:1.0`).
- Keeps what is DID- and web-specific: DID syntax, the DID-to-HTTPS transformation,
  portability, `did:key` witnesses, implicit `#files` / `#whois` (at risk), parallel `did:web`,
  and the DID Resolution options, metadata and errors. Everything else is by reference to VH-Log.
- Adds VH-Log's copy-checking options and the `logForked` / `insufficientCopies` errors.
- Known v1.0 incompatibilities, listed as issues in its "Compatibility with `did:webvh` v1.0"
  section: whole-second `versionTime`; `null` parameter values; watcher notification `?did=`
  vs. VH-Log's `?id=`; non-HTTP watcher URIs.

## Site Update Backlog

Agreed so far: introduce the spec family, and fix out-of-date material. Confirm scope and
structure with the user before large rewrites.

1. **Introduce VH-Log, did:vh and the experimental spec.** Probably a "Specifications" area
   replacing the single iframe page (`./specification.md`), with a page each explaining how
   they relate. Update `./README.md` and `./overview.md` to position `did:webvh` within the
   family.
2. **Migrate off MkDocs.** The target is not yet chosen. Keep the published URLs working
   (`/latest/...` paths from `mike` are linked from the specs, for example
   `https://didwebvh.info/latest/implementers-guide/prerotation-keys/` and
   `https://didwebvh.info/latest/example/`). Check the specs for every didwebvh.info link before
   changing paths.
3. **Implementations** (`./implementations/`). The current branch `update-impl-depl` already
   has work on the implementations and adoption pages. Cross-check against the implementation
   list in the spec header (`/d2/repos/didwebvh/spec/header.md`) and the test suite's
   `implementations/` folder.
4. **Test suite.** Add a page on the interoperability test suite,
   <https://github.com/decentralized-identity/didwebvh-test-suite> (local clone
   `/d2/repos/didwebvh-test-suite`, `origin` is the `swcurran` fork; see its README and
   CLAUDE.md). It holds language-agnostic YAML scenario scripts; each implementation generates
   its own logs and cross-resolves everyone else's, and differences become spec questions. It
   targets v1.0. Implementations currently covered: ts, python, rust, java, java-eecc, dart,
   thisdid; per-implementation results are in `implementations/<impl>/status.md`.
5. **Review for staleness.** Likely candidates:
   - `./version.md` (release notes) and `./example.md` (check against v1.0).
   - Implementer's guide pages that now overlap VH-Log (resolver algorithm, valid keys,
     pre-rotation, witnesses) and `./faq/Duplicity.md` (VH-Log now has resolver-side copy
     comparison). Decide whether each stays did:webvh-specific or points to VH-Log.
   - `./resolution-errors.md` (newer specs add `invalidOptions`, `featureNotSupported`,
     `logForked`, `insufficientCopies`; DID Resolution's own error names are moving to
     `INVALID_DID`-style).
   - `./agenda.md`, `./did-rubric-evaluation.md`, `./demos/`.
   - Remaining `did:tdw` / v0.x references, other than in history.
