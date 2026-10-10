# Understanding did:webvh DID Log Entry Details

This tutorial will help you understand each step in the creation of `did:webvh` DID log entries, a crucial part of the `did:webvh` DID Method. The entry log contains the verifiable record of all the updates made to a did:webvh DID, moving the "trust" of a `did:webvh` DID from DNS to the verifiable log. DNS is still important for discoverability, but the log is where confidence in the provenance of the DID is maintained. In this tutorial we will carry out the manual steps to create a `did:webvh` DID, inspecting the inputs and outputs of each step, and the resulting entry log. In a real deployment, this all happens automatically, but understanding the steps will help you understand how the `did:webvh` method works, and how to integrate it into your own applications.

## Audience

This tutorial is anyone who wants to understand the details of how the `did:webvh` method works, including the low level steps in creating and updating `did:webvh` DIDs. This includes those interested in the DID Method, and those tasked with integrating the existing implementations into their technical stack, or developing their own implementation of the DID Method.

## Prerequisites

- Basic understanding of DIDs and the `did:webvh` method, including terms like SCID (self-certifying identifiers), Data Integrity proofs, JSON, and verifiable credentials.
- Access to and familiarity with command line tools.
- A docker environment set up on your machine.
  - Note, you could use GitHub CodeSpaces or [Play With Docker](https://labs.play-with-docker.com/) if you don't have Docker installed locally.
- A GitHub account, and the ability to create and clone a repository, and run git commands.

## Step 1: Setting up Your Environment

The tutorial is run from a clone of a GitHub repo that you control and into which your DIDs will be published. We'll use GH-Pages as the DID hosting mechanism.

To set up the environment:

- Go to the [did:webvh Tutorial GitHub template repository] in you browser.
- Click the "Use this template" button, choose the "Create a new repository" button, and create the new repository in your GitHub account. We recommend using the name `didwebvh-tutorial`.
- In your new repository, go into the `Settings`, `Pages`, and activate GitHub Pages using the `main` branch/root folder as the source. This will allow you to publish your `did:webvh` DID Log file at `https://<your-username>.github.io/didwebvh-tutorial/did.jsonl`.
- Go the command line where you will run the tutorial and clone the repository you just created by running:

[did:webvh Tutorial GitHub template repository]: https://github.com/OpSecId/didwebvh-tutorial

```bash
git clone https://github.com/<your-username>/didwebvh-tutorial.git
cd didwebvh-tutorial
```

Next, up we need to create the docker images you will be using and bring up the containers. The `docker-compose.yml` file in the repository defines the services we will be using, including an instance of [ACA-Py] for running the cryptographic commands and managing the `did:webvh` DID and key pairs, and a webvh CLI to interact with the ACA-Py agent and generate the DID log entries. Run these commands:

```bash
docker compose up -d --build
docker exec webvh-tutorial-cli webvh # To verify that the webvh CLI is running
alias webvh-cli="docker exec webvh-tutorial-cli webvh"  # Create an alias for convenience
webvh-cli --help # To verify that the webvh CLI is working directly
```

Tips:

- If you ever want to reset the environment, add the `--force-recreate` option to the `docker compose up` command. This will recreate the containers and reset the state.
- To stop the running containers, you can use the `docker compose down` command.
- As you run the commands, take a look at the `outputs` folder (`ls -al outputs`) to see the files that are created. Take a look at the files that created and updated as you go.

[ACA-Py]: https://aca-py.org/

## Step 2: Your First did:webvh Log Entry

Now that we have our environment set up, we can start creating our `did:webvh` DID. We'll run the a number of CLI commands to build up the first log entry of our new `did:webvh` DID.

1. We need to start with the HTTP URL where your new DID will reside. In this case, we're going to put it at the root of the GH Pages published from your new repository -- at `https://<your-username>.github.io/didwebvh-tutorial`. This URL will be the origin of your DID.
    1. Run: **`webvh-cli new-did --origin https://<your-username>.github.io/didwebvh-tutorial`**
    2. The output of the command (file `outputs/did.json`) contains a "templatized" version of what will be the initial DID document. We're using the simplest DID Document possible, containing only the minimum required data (according to the [DID Core Specification]) -- the JSON-LD context, and the ID of the DID itself. "Templatized" means that it contains placeholders (`{SCID}`) for the SCID -- that will be calculated and inserted later. Like any DID Controller, you can populate this DID Document with whatever (valid) content you like. If you add more references to the DID, make sure to use the `{SCID}` literal wherever it is needed.
2. Next we'll define the `did:webvh` DID parameters for the DID. Again, we are going to stick to the minimum required by the `did:webvh` spec -- just the SCID, the method, and a single "authorization key" that will be used to demonstrate the authority to create and update the DID.
    1. Run: **`webvh-cli new-key`**, which will use the ACA-Py instance to create an Ed25519 key pair, printing the multikey public key as the command output. The private key will be held safely in the ACA-Py agent. and used to sign proofs in later steps.
    2. Run: **`webvh-cli did-params --method 1.0 --update-key <pub-auth-key>`**, where `<pub-auth-key>` is the public key of the authorization key created by the previous command. While `method` (currently) defaults to 1.0, we wanted to highlight that defining the specification version controls how the entries are processed, what cryptography can be used, and other deployment details. See the [cryptographic agility] section of the `did:webvh` specification.
    3. The output (file `outputs/parameters.json`) contains the parameters JSON for your new DID, including the public authorization key, the version of the `did:webvh` spec you are using, and the SCID (as a placeholder `{SCID}`).
3. Next we will combine what we have so far into the SCID input file, so we'll be ready to generate the SCID.
    1. Run: **`webvh-cli gen-scid-input --version-time <datetime>`**, where `<datetime>` is the current date and time in ISO 8601 format (e.g., `2025-06-01T17:00:00Z`).
    2. Normally, the DID generation software would set the `versionTime` to the current time, but for this tutorial, we want to show that it is the DID Controller setting that -- self-attested.
    3. Review the output (file `cat outputs/scid_input.json`), which contains something that looks like a DID log entry, with the SCID placeholder where the SCID is needed.
4. Generate the SCID.
    1. Run: **`webvh-cli gen-scid-value`**. The output is the SCID for your DID. It will be different every time you run this tutorial, as it minimum, the authorization key will be different. This step updates the file `outputs/draft_log_entry.json` if you want to check it out.
5. Populate the `versionId` by generating a hash over the DID log entry as it currently stands.
    1. Run: **`webvh-cli gen-version-id`**.
    2. The output (file `outputs/log_entry.json`) contains most of the DID Log Entry. Missing is just the Data Integrity proof, which will be added in the next step.
6. Generate the Data Integrity proof demonstrating the authority to create/update a DID Log Entry.
    1. Run: **`webvh-cli add-proof --update-key <pub-auth-key>`**, where the `<pub-auth-key>` is the public key of the authorization key created earlier. You can copy it from the `updateKeys` element of the output of the previous command. The proof is generated by the CLI calling to the ACA-Py agent, passing in the public key (enabling the private key to be found), and the log entry to be signed.
    2. The output (file `outputs/log_entry.json`) is the complete DID Log Entry, including the Data Integrity proof.
7. Finally, we will update the (currently empty) DID Log file, adding our new Entry into the log file. We'll do this step after we finish preparing each log entry.
    1. Run: **`webvh-cli new-line`**, which will take the log entry `outputs/log_entry.json`, remove all the unnecessary white space (per the [JSON Lines] specification) and append it to the DID Log file `outputs/did.jsonl`. Our new log entry is ready for publication. As an added bonus, the command also updates the `outputs/did.json`, the [`did:web`][did-web] equivalent of our `did:webvh` DID.
    2. Take a look at the files `outputs/did.jsonl` (`did:webvh` Log File) and `outputs/did.json` (`did:web` DID Document).

We have our first `did:webvh` DID ready for publication! At this point, you would typically have some sort of automated process to publish the `did:webvh` DID Document to the right place on the web. For example, ACA-Py has a [did:webvh plugin] that interacts with the [did:webvh Server] to publish the DID. But we'll go old school in this tutorial and have you publish the DID Document by committing files to your GitHub repository.

[DID Core Specification]: https://www.w3.org/TR/did-core/
[JSON Lines]: https://jsonlines.org/
[did-web]: https://www.w3.org/TR/did-web/
[did:webvh plugin]: https://plugins.aca-py.org/latest/webvh/
[did:webvh Server]: https://github.com/decentralized-identity/didwebvh-server-py
[cryptographic agility]: https://identity.foundation/didwebvh/v1.0/#cryptographic-agility

## Step 3: Publishing Your did:webvh Log File

Now that we have our `did:webvh` DID Log file ready, we can publish it to the web. This is done by committing changes in your GitHub repository.

1. From the command line, copy the files `did:webvh` and `did:web` files to the root of your repository with the command **`cp outputs/did.jsonl outputs/did.json .`**.
2. Check your git status (**`git status`**), and if all is good, add the files to your Git staging area with the command **`git add did.jsonl did.json`**.
3. Commit the changes with the command **`git commit -m "Add did:webvh DID Log file"`**.
4. Push the changes to your GitHub repository with the command **`git push origin main`**. That should push the changes to your repository, and you should see the two new files appear in your repository via GitHub interface.
5. To see if everything is working, let's see if we can resolve your DIDs using the DIF Universal Resolver.
   1. View the `did:web` DID Document (`cat did.json`) and copy the `alsoKnownAs` value from the DID Document. This is your `did:webvh` DID.
   2. Go to the [Universal Resolver] (from the [Decentralized Identity Foundation]) and paste your `did:webvh` DID into the input box, and click "Resolve". Your `did:webvh` DID should be resolved.
      1. Didn't work? Did you remember to set up GitHub Pages for your repository? If not, go back to the [Step 1: Setting up Your Environment](#step-1-setting-up-your-environment) section and make sure do that, and the GH-Pages have been published.
   3. Click the "View DID Document" button to see the DID Document that was generated from the Log Entry. Also look at the DID Metadata, to see what is returned by the `did:webvh` resolver.
   4. Remove the `vh:` and the SCID in the DID input box so that now have the `did:web` DID that you also published. Click "Resolve" and your `did:web` DID should be resolved. Again, look at the DID Document and the DID Metadata to see what is returned by the `did:web` resolver for your DID.

You might notice in the resolved `did:webvh` DID Document there are two DID `services` that are not in original DID Document that became the value of the `state` attribute in the Log entry. This is because the `did:webvh` method is defined to automatically add those services to the DID Document when it is resolved if they are not explicitly defined in the DID Document by the DID Controller.

- The first is `#files` service, which results in DID URL paths to be found by using the same DID-To-HTTP transformation as for the DID itself, meaning that `<did>/path/to/file` will resolve to `<http URL>/path/to/file` as one would expect for a web-based DID Method.
- The second is the `#whois` service, that is described in the [whois](https://identity.foundation/didwebvh/v1.0/#the-whois-use-case) section of the did:webvh specification.

For information on these services, see the [DID URL Resolution](https://identity.foundation/didwebvh/v1.0/#did-url-resolution) section of the `did:webvh` specification.

Congratulations! You have successfully created and published your first `did:webvh` DID Log file.

[Universal Resolver]: https://dev.uniresolver.io/
[Decentralized Identity Foundation]: https://identity.foundation/

## Step 4: Updating Your did:webvh DID

Now that we have our first `did:webvh` DID published, let's update it. The process is similar to creating the initial DID, but with some steps skipped. Depending on the goal of the update, we might change the our DID Document, are parameters, or both. In this example, we will update the DID Document to add a new key pair, and the related `verificationMethod` in the DID Document. We'll leave the parameters unchanged, but you could change them if you wanted to.

1. Create a new key pair and add the public key as a `verificationMethod` in the DID Document.
    1. Run: **`webvh-cli new-key`**. As before, this will create a new Ed25519 key pair, printing the multikey public key as the command output. The private key will be held safely in the ACA-Py agent. If you want a different key type for your DID's `verificationMethod`, you will have to use the ACA-Py agent directly to create the key pair and produce the multikey representation of its public key. As noted in the `did:webvh` spec, while the `did:webvh` authorization key **MUST** be of a type defined in the specification (which, for v1.0 is only Ed25519), the DID Document may use any key type that meets the needs of the DID Controller.
    2. Run: **`webvh-cli add-vm --multikey <pub-new-key>`**, where `<pub-new-key>` is the public key of the new key pair created by the previous command.
          1. The output (file `outputs/draft_log_entry.json`) contains the draft DID Log Entry, with the new `verificationMethod` added to the DID Document. Since we are changing the parameters, the `parameters` attribute could be just `{}`, indicating no changes. If you are adventurous, you could create a new authorization key for the DID, and update the `updateKeys` array to use its public multikey. While that will not affect what we do in the current DID update, it will change the authorization key used for a subsequent update.
          2. Note in the `outputs/draft_log_entry.json` file that the `versionId` is still the `versionId` from the first Log entry. This is required by the `did:webvh` specification, resulting in the `versionId` for each entry being dependent on the previous entry. This is what creates the chain of trust in the `did:webvh` Log.
2. Generate the `versionid` for the new Log Entry.
    1. Run: **`webvh-cli gen-version-id`**.
    2. The output (file `outputs/log_entry.json`) contains the DID Log Entry, including the updated `versionId` value.
3. Add the Data Integrity proof to the Log Entry.
    1. Run: **`webvh-cli add-proof --update-key <pub-auth-key>`**, where `<pub-auth-key>` is the public key of the authorization key created earlier. If you put a new authorization key in the parameters of this update, you still use the key from the *first entry* for this command. The new one would not be used until the next update. Trying to use the new authorization key for this update will result in an error.
    2. The output (file `outputs/log_entry.json`) is the complete DID Log Entry, including the Data Integrity proof.
4. And as we did with the first log entry, the last pre-publication step is to add our new log entry to the DID Log file.
    1. Run: **`webvh-cli new-line`**, which will take the log entry (`outputs/log_entry.json`), do the [JSON Lines] processing, and append it to the DID Log file `outputs/did.jsonl`. Our update log file is ready for publication, as is the `did:web` DID Document (`outputs/did.json`) -- updated to match the `did:webvh` DID.
    2. Take a look at the files `outputs/did.jsonl` (`did:webvh` Log File) and `outputs/did.json` (`did:web` DID Document).
5. Last set of commands -- repeat all of the "Step 3: Publishing Your did:webvh Log File" [steps](#step-3-publishing-your-didwebvh-log-file) to publish the updated DID Log file to your GitHub repository, and use the [Universal Resolver] to resolve the DID to see its updates.

Congratulations! You have successfully updated your `did:webvh` DID Log file! You can now use this DID to create and manage DIDs in the `did:webvh` method, and you can continue to update it as needed.

## Conclusion

In this tutorial, you have learned the manual steps in creating and updating a `did:webvh` DID, and one (also manual) way to publish that DID. While a production deployment will have a much higher level of automation, we hope this tutorial has shown you the underlying mechanics of how the method works, and how the entry log is used to maintain the verifiability of the DID, independent of its DNS location. Armed with this knowledge, you can extend your decentralized identity capabilities by deploying the `did:webvh` [implementations](../implementations.md available today, or creating your own implementation to meet your specific needs.

There are additional features and capabilities in the `did:webvh` DID method, such as portability, pre-rotation, watchers and witnesses not covered in this tutorial. As well, there are other tools, such as the [did:webvh Server], and capabilities for building verifiable credential support rooted in `did:webvh` (such as support for [AnonCreds with did:webvh](https://identity.foundation/didwebvh/anoncreds-method/)).

You can continue to explore the `did:webvh` method by creating more DIDs, updating them, and experimenting with different parameters and DID Documents. The `did:webvh` method is designed to be flexible and extensible, allowing you to create DIDs that meet your specific needs.
If you have any questions or feedback about this tutorial, please feel free to reach out via issues in the [did:webvh Tutorial GitHub template repository], the [did:webvh specification repository] or via the `did:webvh` channel on [DIF Slack](https://identity.foundation/slack/).

[did:webvh specification repository]: https://github.com/decentralized-identity/didwebvh
