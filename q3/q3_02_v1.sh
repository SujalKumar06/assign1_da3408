#!/usr/bin/env bash
# Q3 step 2 - fetch data.zip, build the 1800-row CSV, commit and push v1. Run from the repo root.

echo "=== fetching data.zip ==="
dvc get https://github.com/iterative/dataset-registry tutorials/versioning/data.zip
unzip -q data.zip && rm -f data.zip

echo "=== image count (expect 1800) ==="
find data -type f -name '*.jpg' | wc -l

echo "=== building file_index.csv ==="
{ echo "filename,label,split"
  find data -type f -name '*.jpg' | sort | awk -F/ '{print $NF","$(NF-1)","$(NF-2)}'
} > file_index.csv

echo "=== line count (expect 1801 = 1800 rows + header) ==="
wc -l file_index.csv
head -3 file_index.csv

echo "=== dvc add + commit v1 ==="
dvc add data
dvc add file_index.csv
git add .gitignore data.dvc file_index.csv.dvc
git commit -m "Add first version of data/ and file index (1800 rows + header)"
git tag -f -a v1 -m "data v1, 1800 images, 1800 CSV rows"

echo "=== dvc push ==="
dvc push
