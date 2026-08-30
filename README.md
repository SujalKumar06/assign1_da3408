# AI Operations (AIOps): DA3408 Module 1 Assignment

Experiment Management & Reproducibility.

```
q1/   aiops_q1.pdf          conceptual answer (technical debt diagnosis)
q2/   question_2.ipynb      MLflow experiment tracking on MNIST + MLP
q3/   *.sh, *.dvc           DVC data versioning and rollback (its own git repo)
q4/   -                     capstone, in a separate repo (see below)
```

## Environment

Create the environment from `environment.yml`:

```bash
mamba env create -f environment.yml     # or: conda env create -f environment.yml
conda activate aiops-q4
```

---

## Q2: MLflow experiment comparison

Start the tracking server in a separate terminal and leave it running:

```bash
mlflow server \
  --backend-store-uri sqlite:///mlflow.db \
  --default-artifact-root ./mlruns \
  --host 127.0.0.1 --port 5000
```

Then run the notebook top to bottom:

```bash
jupyter lab q2/question_2.ipynb
```

Open the UI at <http://localhost:5000> and look at experiment `mnist-mlp-q2`.
Use `localhost`, not `0.0.0.0`, as the server rejects `0.0.0.0` as a cross-origin
request and the UI fails with `INTERNAL_ERROR`.

---

## Q3: DVC data versioning and rollback

`q3/` is a separate git repository with its own DVC setup. Run everything from
inside it:

```bash
cd q3
```

The remote is an S3 bucket recorded in `.dvc/config`; credentials are not in the
repo, so supply your own first:

```bash
aws configure          # access key, secret key, region ap-south-1
```

**Without AWS credentials you will not be allowed to push.** The bucket is
private, so `dvc push` fails with an access-denied error unless you have your own
key configured for it. Everything else still works locally: the scripts build the
CSV, run `dvc add`, and make the git commits and tags, and `q3_03_rollback.sh`
demonstrates the rollback from the local cache. Only the `dvc push` step at the
end of the first two scripts needs the bucket.

Then run the three scripts in order:

```bash
./q3_01_v1.sh          # data.zip -> CSV (1801 lines) -> tag v1 -> dvc push
./q3_02_v2.sh          # new-labels.zip -> CSV (2801 lines) -> tag v2 -> dvc push
./q3_03_rollback.sh    # git checkout v1 + dvc checkout, before/after row counts
```

If they are not executable:

```bash
chmod +x q3_01_v1.sh q3_02_v2.sh q3_03_rollback.sh
```

Each script echoes the expected count next to every check (`expect 1800`,
`expect 2801`, and so on), so a mismatch is visible as it scrolls past.

To save the rollback output as evidence:

```bash
./q3_03_rollback.sh 2>&1 | tee screenshots/rollback_output.txt
```

---

## Q4: End-to-end reproducibility drill

The capstone was done jointly with a partner and lives in its own repository:

<https://github.com/samrudh123/q4>
