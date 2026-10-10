#!/bin/bash

# A script to prep for testing of mkdocs generation, and then to clean up after
# Called as the file preparation step in the .github/workflows/publish-docs Git Hub Action
#
# Add argument "clean" to remove the copied files when just being used for testing.

# The root level md files used for the "Contributing" pages in mkdocs.yml
ROOT_FILES="README.md CONTRIBUTOR.md CODE_OF_CONDUCT.md"

if [[ "$1" == "clean" ]]; then
  rm -f docs/root_*
else
    # Copy the root level md files into the docs folder for deployment, tweaking the relative paths
    # Preface their names with "root_"
    for i in $ROOT_FILES; do sed \
      -e "s#docs/#./#g" \
      $i >docs/root_$i; done
fi
