# did:webvh DID Method - Information

This is the information site/repository for the **did:webvh ("`did:web` + Verifiable History") DID Method**. This DID Method was formerly called `did:tdw` ("Trust DID Web").

`did:webvh` information is published at [https://didwebvh.info](https://didwebvh.info)

The `did:webvh` specification is published at [https://identity.foundation/didwebvh](https://identity.foundation/didwebvh)

## Contributing

Contributions to this information site are welcome! Feel free to improve the
content found here about the DID Method:

- talk about what you have done with `did:webvh`,
- share information about the `did:webvh` software you have written,
- tell us about the services you offer in deploying `did:webvh`, or
- anything else you can think of about `did:webvh`.

The `did:webvh` information site is a [MkDocs Material] site generated from the
Markdown files in the site's [GitHub repository].

[MkDocs Material]: https://squidfunk.github.io/mkdocs-material/
[GitHub Repository]: https://github.com/decentralized-identity/didwebvh-info

Contributions can be made via pull requests (PRs) to the GitHub repository that will
be reviewed and (if relevant) merged. You can use the GitHub website itself to add or
edit files, or fork the repo and edit them in your favorite GitHub-friendly
editor.  Each commit of a PR must have a DCO (Developer Certificate of Origin -
[https://github.com/apps/dco](https://github.com/apps/dco)) sign-off -- handled
automagically on the GitHub website or, if done from the command line, by adding
the `-s` (lower case) option on the `git commit` command (e.g., `git commit -s
-m "Comment about the commit"`).

### Previewing the Site Locally

To check your changes before creating your pull request, build and serve the
site locally. From the root folder of the repository:

1. Install the same versions of MkDocs Material and `mike` that the
   publishing workflow uses (a Python virtual environment is a good idea):

    ```bash
    pip install -r mkdocs-requirements.txt
    ```

2. Copy the Markdown files from the root folder (this `README.md`,
   `CONTRIBUTOR.md` and `CODE_OF_CONDUCT.md`) into the `docs` folder:

    ```bash
    ./scripts/prepmkdocs.sh
    ```

    The "Contributing" pages of the site are built from these files. The
    script copies each one into `docs` as `root_<name>.md`. Without this step
    the "Contributing" pages are missing (404) in your local site.

3. Serve the site, and open your browser to the address it shows (usually
   <http://127.0.0.1:8000>). The site reloads as you edit the files.

    ```bash
    mkdocs serve
    ```

4. When you are done, remove the copied files so they aren't committed:

    ```bash
    ./scripts/prepmkdocs.sh clean
    ```

Edit the root Markdown files themselves, not the `root_*.md` copies in the `docs` folder,
which are overwritten each time the script is run.

The published site is built the same way: the [publish-docs workflow] runs
`scripts/prepmkdocs.sh` and then uses `mike` to publish the `main` branch as the
`latest` version of the site.

[publish-docs workflow]: https://github.com/decentralized-identity/didwebvh-info/blob/main/.github/workflows/publish-docs.yml
