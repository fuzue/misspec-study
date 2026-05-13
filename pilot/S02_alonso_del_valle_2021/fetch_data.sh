#!/usr/bin/env bash
# Reproducibly fetch the Alonso-del Valle et al. 2021 OD growth-curve data.
#
# Paper:  Alonso-del Valle, A. et al., Nat. Commun. 12, 2653 (2021).
# DOI:    10.1038/s41467-021-22849-y
# GitHub: https://github.com/ccg-esb/pOXA48
# Zenodo: https://doi.org/10.5281/zenodo.4605352  (snapshot ccg-esb/pOXA48-v1.zip, 1.24 GB)
#
# Two fetch modes:
#   1. Lightweight (default): downloads only the per-strain OD time-series CSVs
#      from raw.githubusercontent.com plus README/MCMC parameter summaries.
#      Total: ~3.5 MB across 100+ CSVs.
#   2. Full (--full):          downloads the 1.24 GB Zenodo snapshot ZIP that
#      pins the v1 state of the repository (MCMC chains, MATLAB code, etc.).
#
# Usage:
#     bash fetch_data.sh                # mode 1
#     bash fetch_data.sh --full         # mode 2
#     bash fetch_data.sh raw            # mode 1, write into ./raw
#     bash fetch_data.sh --full raw     # mode 2, write into ./raw

set -euo pipefail

MODE="lightweight"
DEST_DIR=""

for arg in "$@"; do
  case "$arg" in
    --full) MODE="full" ;;
    -h|--help)
      sed -n '1,25p' "$0"; exit 0 ;;
    *)  DEST_DIR="$arg" ;;
  esac
done

DEST_DIR="${DEST_DIR:-$(dirname "$0")/raw}"
mkdir -p "$DEST_DIR"
cd "$DEST_DIR"

# Zenodo blocks plain HEAD/CURL UAs; a browser-style UA is required for GET.
UA="Mozilla/5.0 (X11; Linux x86_64) Gecko/20100101 Firefox/115.0 misspec-study/pilot"
GH_API="https://api.github.com/repos/ccg-esb/pOXA48"
GH_RAW="https://raw.githubusercontent.com/ccg-esb/pOXA48/master"

if [[ "$MODE" == "full" ]]; then
  echo ">> Full mode: pulling 1.24 GB Zenodo snapshot."
  curl -sSL -A "$UA" --fail \
    "https://zenodo.org/api/records/4605352/files/ccg-esb/pOXA48-v1.zip/content?download=1" \
    -o "pOXA48-v1.zip"
  echo ">> Done. To extract: unzip pOXA48-v1.zip"
  exit 0
fi

echo ">> Lightweight mode: pulling per-strain OD CSVs + parameter summaries."

mkdir -p ODdata_strains
cd ODdata_strains

# List the directory via the GitHub contents API and download each CSV.
# (per_page=200 is enough for the 100 files; bumped to be future-proof.)
curl -sSL -A "$UA" --fail \
  "${GH_API}/contents/data/ODdata_strains?per_page=200" \
  -o _listing.json

python3 - <<'PY'
import json, urllib.request, os, sys
with open("_listing.json") as f:
    items = json.load(f)
csvs = [it["name"] for it in items if it["name"].endswith(".csv")]
print(f"   -> {len(csvs)} CSVs to fetch")
for name in csvs:
    if os.path.exists(name): continue
    url = f"https://raw.githubusercontent.com/ccg-esb/pOXA48/master/data/ODdata_strains/{name}"
    urllib.request.urlretrieve(url, name)
print("   -> done.")
PY
cd ..

# Also grab the MCMC parameter summary and the README.
curl -sSL -A "$UA" --fail "${GH_RAW}/data/MCMC_params.txt"  -o "MCMC_params.txt"
curl -sSL -A "$UA" --fail "${GH_RAW}/data/MCMC_params.mat"  -o "MCMC_params.mat"
curl -sSL -A "$UA" --fail "${GH_RAW}/README.md"             -o "README.md"

echo
echo "Done. Files in $(pwd):"
ls -lh
echo
echo "Per-strain OD time-series CSVs are in $(pwd)/ODdata_strains/"
ls ODdata_strains | head -5
echo "..."
ls ODdata_strains | wc -l
