The emergence of [Decentralized Identifiers](https://www.w3.org/TR/did-core/)
(DIDs) and with them the evolution of [DID
Methods](https://decentralized-id.com/web-standards/w3c/decentralized-identifier/did-methods/)
continues to be a dynamic area of development in the quest for trusted, secure
and private digital identity management where the users are in control of their
own data.

The [`did:web` method](https://w3c-ccg.github.io/did-method-web/) provides a solution that is recognized 
for its simplicity of deployment and its cost-effectiveness, allowing for easy establishment of a 
credential ecosystem. It leverages the Domain Name System (DNS) to perform the DID operations including 
DID-to-HTTPS transformation and allowing for DIDs to be associated with a domain's reputation or published 
on platforms such as GitHub. This approach is, however, not without its challenges. It is, for example, not 
inherently decentralized as it relies on DNS domain names, which require centralized registries. In addition 
`did:web` lacks a cryptographically verifiable, tamper-resistant, and persistently stored DID document,
including its verifiable history.

We propose the `did:tdw` (Trust DID Web) method presented here as an enhancement of `did:web`, providing a 
solution to address the limitations inherent of `did:web`. `did:tdw` introduces features such as a 
verifiable history, akin to what is available with ledger-based DIDs, but without relying on a ledger,
a self-certifying identifiers (SCIDs), and authorized key(s) to increase controll over the creation, update,
and deactivation of a DID. Furthermore, the `did:tdw` method provides a more decentralized approach by ensuring 
that the security of the embedded SCID does not depend on DNS, and enables resolving a cryptographically 
verifiable trust registry and status lists, using DID-Linked Resources, which `did:web` lacks. 

In summary, the `did:tdw` method offers a higher level of assurance for those requiring more robust verification 
processes compared to what is provided by `did:web`. It also represents a significant stride towards a more 
trusted and secure web, where the integrity of cryptographic key publishing and management is paramount. 
In addition, `did:tdw` maintains backward compatibility with `did:web` and the resulting DID can be published 
as both `did:web` and `did:tdw`. These possibilities carter to a flexible and broader range of use cases and 
corresponding trust requirements, addressing both those who are comfortable with the existing `did:web` 
infrastructure to those seeking greater security assurances provided by `did:tdw`. 

---


### A `tl;dr` summary of `did:tdw`

> 
> #### The `did:tdw` Structure *(or, where is the `DID Doc`?)*
>
> - `did:tdw` uses a so-called DID Log to publish cryptographic material and capabilities
> - A `DID Log` is stored as `did.jsonl` file and represents a list of entries, each formatted as JSON line
> - Every `DID Log Entry` describes a specific version of the corresponding DID via a JSON object
>    
>    - DID Log Entry := `{ "versionId": "", "versionTime": "", "parameters": {}, "state": {}, "proof" : [] }`  
>        - `versionId` -- a value that combines the version number (starting at `1` and incremented by one per version), followed by a literal dash `-`, and a hash of the entry, which links each entry to its predecessor in a ledger-like chain
>        - `versionTime` -- a string in UTC ISO8601 format 
>        - `parameters` -- a set of parameters that impact the processing of the current and future log entries
>            - method
>            - SCID
>            - updateKeys
>            - portable (optional)
>            - prerotation (optional)
>            - nextKeyHashes (optional)
>            - witnesses (optional)
>            - deactivated (when accurate)
>            - ttl (optional)
>       - `state` -- the current version of the DIDDoc
>       - `proof`-- a Data Integrity (DI) proof calculated across the entry, signed by a DID Controller authorized key to update the DIDDoc, and optionally, a set of witnesses that monitor the actions of the DID Controller
> 
> - The entire `DID Doc` is part of the "state" object *(in every JSON line of a DID Log Entry within the DID Log File)*
> 
> 
> #### Creating the first DID Doc
>
> 1. Create a preliminary log entry
>    - Create the JSON structure with the aforementioned properties and the following values:
>       - `versionId` := the literal string "`{SCID}`"
>       - `versionTime` := as asserted by the DID Controller, for example, `"2024-04-05T07:32:58Z"`
>       - `parameters` := as needed and defined by the DID Controller, for example:
>            - method := `did:tdw:0.4`
>            - SCID := the literal string "`{SCID}`" (here and wherever the calculated SCID value will eventually be placed)
>       - `state` := initial DID Doc with placeholders (the literal string "`{SCID}`") wherever the calculated SCID value will eventually be placed
>        - *`proof` := not set at this point. Will be set in step 4 below*
>
> 2. Calculate the SCID
>    - SCID := `base58btc(multihash(JCS(preliminary log entry with placeholders), <hash algorithm>))`
>       - `JCS` := an implementation of the [[ref: JSON Canonicalization Scheme]] [[spec:rfc8785]]
>       - `multihash` := an implementation of the [[ref: multihash]] specification
>       - `<hash algorithm>` := one of the hash algorithms accepted by  `did:tdw` (see [parameters](#didtdw-did-method-parameters))
>       - `base58btc` := an implementation of the [[ref: base58btc]] function
>
> 3. Update the preliminary log entry
>    - Replace all placeholders (the literal string `{SCID}`) with the calculated SCID value
>    - For the `versionId` start with `1` followed by a literal dash `-`
>
> 4. Calculate the data integrity (DI) proof
>    - `proof` := a proof calculated across the *entire* DID Log Entry and signed with an updateKeys (and optionally by the witnesses). Values of required attributes include:
>       - type := eddsa-jcs-2022
>       - proofPurpose := `assertionMethod`
>
> 5. Add the DI proof to the `proof` property of the DID Log Entry
>
> #### Creating the first DID Log
>
> - Turn the Log Entry into a JSON Line according the [[ref JSON Lines]] specification and add the line to the DID Log File for publication
>
> #### Some considerations
>    - DID update
>       - The SCID is only calculated for the very first DID Log Entry and not for consecutive DID updates (i.e., new DID Log Entry)
>       - Instead of a SCID, each a new EntryHash is calculated in a similar way, for every consecutive DID Log Entry
>            - EntryHash := `base58btc(multihash(JCS(entry), <hash algorithm>))`
> - Note: Both the SCID and the EntryHash are calculated *before* the DI proof calculation
> - `did:tdw` uses the same DID-to-HTTPS transformation as `did:web`, so `did:tdw`'s  `did.jsonl` (JSON Lines) file is found in the same location as `did:web`'s `did.json` file, and supports an easy transition from `did:web` to gain the added benefits of `did:tdw`.
> - For backwards compatibility, and for verifiers that "trust" `did:web`, a
`did:tdw` can be trivially modified and published in parallel to a `did:web`
DID. For resolvers that want more assurance, `did:tdw` provides a way to "trust
did:web" (or to enable a "trusted web" if you say it fast) enabled by the
features listed in the [introduction](./README.md).
   
----

  ::: warning
    A resolver settling for just the `did:web` version of the DID does not get the
    verifiability of the `did:tdw` log.
  :::

