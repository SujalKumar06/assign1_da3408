#!/usr/bin/env bash
# Q3 step 2 - add new-labels.zip, rebuild the CSV at 2801 lines, commit and push v2. Run from the repo root.

echo "=== fetching new-labels.zip ==="
dvc get https://github.com/iterative/dataset-registry tutorials/versioning/new-labels.zip
unzip -q -o new-labels.zip && rm -f new-labels.zip

echo "=== dvc diff (expect: Modified data/) ==="
dvc diff

echo "=== image count (expect 2800) ==="
find data -type f -name '*.jpg' | wc -l

echo "=== rebuilding file_index.csv ==="
{ echo "filename,label,split"
  find data -type f -name '*.jpg' | sort | awk -F/ '{print $NF","$(NF-1)","$(NF-2)}'
} > file_index.csv

echo "=== line count (expect 2801 = 2800 rows + header) ==="
wc -l file_index.csv

echo "=== re-run dvc add + commit v2 ==="
dvc add data
dvc add file_index.csv
git diff data.dvc
git commit -am "New version of data with more training images (2800 rows + header)"
git tag -f -a v2 -m "data v2, 2800 images, 2800 CSV rows"

echo "=== dvc push ==="
dvc push
