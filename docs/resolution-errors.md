# `did:webvh` Resolution Error Codes

did:webvh Resolution Error Codes
This page defines the set of structured error codes and messages used in `did:webvh` DID resolution metadata, specifically in the `problemDetails` field as defined by [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457).

## Using RFC 9457 in did:webvh

When DID resolution fails, `did:webvh` resolvers **MUST** return an `error` field in the `didResolutionMetadata`, as defined in the [DID Resolution specification](https://www.w3.org/TR/did-core/#did-resolution). To provide additional structured information, resolvers **SHOULD** include a `problemDetails` object conforming to RFC 9457. For example, the DID Resolution Metadata would look like this:

```json
"didResolutionMetadata": {
  "error": "invalidDid",
  "problemDetails": {
    "type": "https://w3id.org/security#INVALID_CONTROLLED_IDENTIFIER_DOCUMENT_ID",
    "title": "The resolved DID is invalid.",
    "detail": "Parse error of the resolved DID at character 3, expected ':'."
  }
}
```

The `problemDetails` object includes the following fields:

- `type`: A URI pointing to this page, with a fragment identifier representing
  the error code from the [list below](#resolution-error-codes). For example the
  [did-log-id-mismatch](https://didwebvh.info/main/resolution-errors/#did-log-id-mismatch)
  error code defined below has the `type` value:

  `https://didwebvh.info/main/resolution-errors/#did-log-id-mismatch`

- `title`: A human-readable title for the error, matching the one listed in the section for the corresponding error code below.
- `detail`: A more specific message describing the error encountered, suitable for developers or technical users.

The list of `title` and `detail` values collected by `did:webvh` resolver implementers is [provided below](#resolution-error-codes).

Resolver implementers **SHOULD** use the `type` and `title` values below and **MAY** use the `detail` or one appropriate for the implementation.

## Implementer Guidance

Resolver implementers should use the errors listed below as standardized codes for communicating resolution failures. If your resolver needs to report an error not listed here, you are encouraged to contribute to this list via a pull request to the [did:webvh information site GitHub repository](https://github.com/didwebvh-info). Please ensure your proposed error includes:

- A clear and unique error code (used as the fragment in the `type` URI)
- A descriptive title
- A concise, developer-friendly detail message

## Resolution Error Codes

### did-log-id-mismatch

**Title:** DID Log for DID being resolved not found  
**Detail:** A DID Log File was found, but the `id` in the DIDDoc does not match the DID `${did}` being resolved.

### conflicting-resolution-options

**Title:** Cannot specify both verificationMethod and version number/id  
**Detail:** Conflicting resolution options were provided in the resolution request.

### unknown-protocol

**Title:** Protocol unknown. 
**Detail:** The protocol '${protocol}' in the DID Log File does not match the expected protocol.

### version-mismatch

**Title:** Version number in log doesn't match expected 
**Detail:** A DID log entry's version number '${version}' does not match the expected sequence '${i + 1}'.

### version-invalid

**Title:** Version number in log is invalid 
**Detail:** A DID log entry's version number '${version}' is zero or not numeric.

### versionid-format-invalid

**Title:** VersionId format is invalid.
**Detail:** A DID log entry's versionId '${versionId}' format is invalid.

### versiontime-format-invalid

**Title:** VersionTime format is invalid.
**Detail:** A DID log entry ('${version}') has a `versionTime` that cannot be parsed as a ISO date-time for comparisons.

### scid-verification-failed

**Title:** SCID not derived from logEntryHash  
**Detail:** SCID ('${meta.scid}') validation failed due to a mismatch in expected hash ('${logEntryHash}').

### proof-verification-failed

**Title:** Version failed verification of the proof  
**Detail:** The proof attached to the version (${meta.versionId}) log entry failed verification.

### portability-disabled

**Title:** Cannot move DID: portability is disabled  
**Detail:** An attempt was made to move a DID, but portability is not enabled in the DID Log.

### hash-chain-broken

**Title:** Hash chain broken  
**Detail:** The cryptographic hash chain was broken at version '${meta.versionId}'.

### verification-method-not-found

**Title:** Verification method not found  
**Detail:** The verification method ${vm} could not be located in the DIDDoc or verification context.

### verification-method-resolution-error

**Title:** Error resolving verification method
**Detail:** A general error occurred while resolving the specified verification method ${vm}.

### key-not-authorized-to-update

**Title:** Key is not authorized to update  
**Detail:** The key ${proof.verificationMethod} used in the proof is not in the list of authorized update keys.

### witness-key-not-authorized

**Title:** Key is not from an authorized witness  
**Detail:** The key ${proof.verificationMethod} used in the proof is not recognized as coming from an authorized witness.
