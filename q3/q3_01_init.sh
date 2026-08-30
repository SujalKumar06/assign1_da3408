#!/usr/bin/env bash
# Q3 step 1 - initialise DVC inside the git repo. Run from the repo root.
# STOP after this and configure the remote by hand (ssh or s3), then run q3_02_v1.sh

echo "=== dvc init ==="
dvc init
git add .dvc/.gitignore .dvc/config .dvcignore
git commit -m "Initialize dvc project"

echo
echo "=== done. now configure the remote manually, e.g. ==="
echo "  dvc remote add --default <name> <url>"
echo "  git add .dvc/config && git commit -m 'Configure remote storage'"
