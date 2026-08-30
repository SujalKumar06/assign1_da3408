#!/usr/bin/env bash
# Q3 step 3 - demonstrate rollback to v1 with git checkout + dvc checkout. Run from the repo root.

echo "=== BEFORE ROLLBACK (v2) ==="
git log --oneline -1
wc -l file_index.csv
md5sum file_index.csv
find data -type f -name '*.jpg' | wc -l

echo
echo "=== git checkout v1 ==="
git checkout v1
dvc diff

echo
echo "=== dvc checkout ==="
dvc checkout
dvc status

echo
echo "=== AFTER ROLLBACK (v1) ==="
git log --oneline -1
wc -l file_index.csv
md5sum file_index.csv
find data -type f -name '*.jpg' | wc -l
tail -2 file_index.csv

echo
echo "=== returning to master ==="
git checkout master
dvc checkout
